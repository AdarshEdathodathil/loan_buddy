import 'package:drift/drift.dart';
import 'package:loan_buddy/core/constants/payment_type.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
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

    final Map<String, double> monthlyTotals = {};

    for (int i = 0; i < months; i++) {
      final date = DateTime(startDate.year, startDate.month + i);

      final key = DateFormat('MMM yy').format(date);
      monthlyTotals[key] = 0;
    }

    for (final payment in payments) {
      final key = DateFormat('MMM yy').format(payment.paymentDate);

      monthlyTotals.update(
        key,
        (value) => value + payment.amount,
        ifAbsent: () => payment.amount,
      );
    }

    return monthlyTotals.entries.map((entry) {
      return MonthlyEmiData(month: entry.key, amount: entry.value);
    }).toList();
  }

  Future<DateTime> getNextUnpaidEmiMonth(int loanId) async {
  final loan = await (db.select(db.loans)
        ..where((l) => l.id.equals(loanId)))
      .getSingle();

  final payments = await (db.select(db.payments)
      ..where((p) => p.loanId.equals(loanId)))
    .get();

final paidMonths = payments
    .map((p) => '${p.emiForMonth.year}-${p.emiForMonth.month}')
    .toSet();

  var current = DateTime(
    loan.startDate.year,
    loan.startDate.month,
  );

  final end = DateTime(
    loan.endDate.year,
    loan.endDate.month,
  );

  while (!current.isAfter(end)) {
    final key = '${current.year}-${current.month}';

    if (!paidMonths.contains(key)) {
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

  await db.into(db.payments).insert(
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

Future<void> makePayment({
  required int loanId,
  required double amount,
  required DateTime paymentDate,
  required String paymentType,
  String? remarks,
}) async {
  await db.transaction(() async {
    final loan = await (db.select(db.loans)
          ..where((l) => l.id.equals(loanId)))
        .getSingle();

    if (loan.isClosed) {
      throw Exception('Cannot make a payment on a closed loan.');
    }

    double paymentAmount = amount;

    switch (paymentType) {
      case PaymentType.emi:
        // EMI payment
        break;

      case PaymentType.partPayment:
        // Partial prepayment
        break;

      case PaymentType.foreclosure:
        // Loan foreclosure
        paymentAmount = loan.outstandingAmount;
        break;

      default:
        throw Exception('Unknown payment type');
    }

    final emiMonth = await getNextUnpaidEmiMonth(loanId);

    await db.into(db.payments).insert(
      PaymentsCompanion.insert(
        loanId: loanId,
        amount: paymentAmount,
        paymentDate: paymentDate,
        emiForMonth: emiMonth,
        paymentType: Value(paymentType),
        remarks: Value(remarks),
      ),
    );

    final outstanding =
    (loan.outstandingAmount - paymentAmount)
        .clamp(0.0, double.infinity);

    final isClosed = outstanding == 0;

    await (db.update(db.loans)..where((l) => l.id.equals(loanId))).write(
      LoansCompanion(
        outstandingAmount: Value(outstanding),
        isClosed: Value(isClosed),
      ),
    );

    if (isClosed) {
      await NotificationService.instance.cancelReminder(loanId);
    }
  });
}

  Stream<List<Payment>> watchPayments(int loanId) {
    return (db.select(db.payments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
        .watch();
  }

  Future<void> deletePayment(int paymentId) async {
    await (db.delete(db.payments)..where((p) => p.id.equals(paymentId))).go();
  }
}
