import 'package:drift/drift.dart';
import 'package:loan_buddy/core/database/app_database.dart';
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

  Future<void> addPayment({
    required int loanId,
    required double amount,
    required DateTime paymentDate,
    String paymentType = 'EMI',
    String? remarks,
  }) async {
    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            loanId: loanId,
            amount: amount,
            paymentDate: paymentDate,
            emiForMonth: paymentDate,
            paymentType: Value(paymentType),
            remarks: Value(remarks),
          ),
        );
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
