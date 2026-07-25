import 'package:drift/drift.dart';
import 'package:loan_buddy/core/database/app_database.dart';

class PaymentRepository {
  PaymentRepository(this.db);

  final AppDatabase db;

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
