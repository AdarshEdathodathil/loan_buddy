import 'package:drift/drift.dart';
import 'package:loan_buddy/core/constants/payment_type.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/money/money_math.dart';
import 'package:loan_buddy/features/analytics/models/monthly_emi_data.dart';
import 'package:intl/intl.dart';

class PaymentRepository {
  PaymentRepository(this.db);

  final AppDatabase db;

  Future<List<MonthlyEmiData>> getMonthlyEmiTrend({int months = 6}) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - (months - 1), 1);

    final payments =
        await (db.select(db.payments)
              ..where((p) => p.paymentDate.isBiggerOrEqualValue(startDate))
              ..orderBy([(p) => OrderingTerm.asc(p.paymentDate)]))
            .get();

    return calculateMonthlyEmiTrend(payments, months: months, now: now);
  }

  List<MonthlyEmiData> calculateMonthlyEmiTrend(
    List<Payment> payments, {
    int months = 6,
    DateTime? now,
  }) {
    final currentDate = now ?? DateTime.now();
    final startDate = DateTime(
      currentDate.year,
      currentDate.month - (months - 1),
      1,
    );
    final Map<String, double> monthlyTotals = {};

    for (int i = 0; i < months; i++) {
      final date = DateTime(startDate.year, startDate.month + i);

      final key = DateFormat('MMM yy').format(date);
      monthlyTotals[key] = 0;
    }

    for (final payment in payments) {
      final key = DateFormat('MMM yy').format(payment.paymentDate);
      if (monthlyTotals.containsKey(key)) {
        monthlyTotals[key] = monthlyTotals[key]! + payment.amount;
      }
    }

    return monthlyTotals.entries.map((entry) {
      return MonthlyEmiData(month: entry.key, amount: entry.value);
    }).toList();
  }

  Future<DateTime> getNextUnpaidEmiMonth(int loanId) async {
    final loan = await (db.select(
      db.loans,
    )..where((l) => l.id.equals(loanId))).getSingle();

    final payments =
        await (db.select(db.payments)..where(
              (p) =>
                  p.loanId.equals(loanId) &
                  p.paymentType.equals(PaymentType.emi),
            ))
            .get();

    final paidByMonth = <String, double>{};
    for (final payment in payments) {
      final key = '${payment.emiForMonth.year}-${payment.emiForMonth.month}';
      paidByMonth.update(
        key,
        (amount) => MoneyMath.normalize(amount + payment.amount),
        ifAbsent: () => MoneyMath.normalize(payment.amount),
      );
    }

    var current = DateTime(loan.startDate.year, loan.startDate.month);

    final end = DateTime(loan.endDate.year, loan.endDate.month);

    while (!current.isAfter(end)) {
      final key = '${current.year}-${current.month}';

      final paid = paidByMonth[key] ?? 0;
      if (MoneyMath.isGreaterThan(loan.emiAmount, paid)) {
        return current;
      }

      current = DateTime(current.year, current.month + 1);
    }

    return end;
  }

  Future<void> addPayment({
    required int loanId,
    required double amount,
    required DateTime paymentDate,
    String paymentType = PaymentType.emi,
    String? remarks,
  }) async {
    final emiMonth = await getNextUnpaidEmiMonth(loanId);

    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            loanId: loanId,
            amount: amount,
            paymentDate: paymentDate,
            emiForMonth: emiMonth,
            paymentType: Value(paymentType),
            remarks: Value(remarks),
          ),
        );
  }

  Future<bool> makePayment({
    required int loanId,
    required double amount,
    required DateTime paymentDate,
    required String paymentType,
    String? remarks,
  }) async {
    if (!PaymentType.values.contains(paymentType)) {
      throw ArgumentError.value(paymentType, 'paymentType', 'Unknown type');
    }

    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be greater than zero');
    }

    final normalizedAmount = MoneyMath.normalize(amount);

    final wasClosed = await db.transaction(() async {
      final loan = await (db.select(
        db.loans,
      )..where((l) => l.id.equals(loanId))).getSingle();

      if (loan.isClosed) {
        throw Exception('Cannot make a payment on a closed loan.');
      }

      final paymentAmount = paymentType == PaymentType.foreclosure
          ? MoneyMath.normalize(loan.outstandingAmount)
          : normalizedAmount;

      if (MoneyMath.isGreaterThan(paymentAmount, loan.outstandingAmount)) {
        throw ArgumentError.value(
          paymentAmount,
          'amount',
          'Cannot exceed the outstanding balance',
        );
      }

      final emiMonth = paymentType == PaymentType.emi
          ? await getNextUnpaidEmiMonth(loanId)
          : DateTime(paymentDate.year, paymentDate.month);

      await db
          .into(db.payments)
          .insert(
            PaymentsCompanion.insert(
              loanId: loanId,
              amount: paymentAmount,
              paymentDate: paymentDate,
              emiForMonth: emiMonth,
              paymentType: Value(paymentType),
              remarks: Value(remarks),
            ),
          );

      final outstanding = MoneyMath.normalize(
        (loan.outstandingAmount - paymentAmount).clamp(0.0, double.infinity),
      );

      final isClosed = MoneyMath.isZero(outstanding);

      await (db.update(db.loans)..where((l) => l.id.equals(loanId))).write(
        LoansCompanion(
          outstandingAmount: Value(outstanding),
          isClosed: Value(isClosed),
        ),
      );

      return isClosed;
    });

    return wasClosed;
  }

  Stream<List<Payment>> watchPayments(int loanId) {
    return (db.select(db.payments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
        .watch();
  }

  Stream<List<Payment>> watchAllPayments() {
    return (db.select(
      db.payments,
    )..orderBy([(p) => OrderingTerm.desc(p.paymentDate)])).watch();
  }

  Future<int?> deletePayment(int paymentId) async {
    return db.transaction(() async {
      final payment = await (db.select(
        db.payments,
      )..where((p) => p.id.equals(paymentId))).getSingleOrNull();

      if (payment == null) return null;

      final loan = await (db.select(
        db.loans,
      )..where((l) => l.id.equals(payment.loanId))).getSingleOrNull();

      await (db.delete(db.payments)..where((p) => p.id.equals(paymentId))).go();

      if (loan == null) return null;

      final restoredOutstanding = MoneyMath.normalize(
        (loan.outstandingAmount + payment.amount).clamp(0.0, loan.totalAmount),
      );

      await (db.update(db.loans)..where((l) => l.id.equals(loan.id))).write(
        LoansCompanion(
          outstandingAmount: Value(restoredOutstanding),
          isClosed: const Value(false),
        ),
      );
      return loan.id;
    });
  }
}
