import 'package:drift/drift.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/features/dashboard/models/analytics_data.dart';

class LoanRepository {

  Stream<AnalyticsData> watchAnalytics() {
  return watchLoans().map((loans) {
    double totalBorrowed = 0;
    double totalOutstanding = 0;
    double monthlyEmi = 0;

    int activeLoans = 0;
    int closedLoans = 0;

    for (final loan in loans) {
      totalBorrowed += loan.totalAmount;
      totalOutstanding += loan.outstandingAmount;
      monthlyEmi += loan.emiAmount;

      if (loan.isClosed) {
        closedLoans++;
      } else {
        activeLoans++;
      }
    }

    return AnalyticsData(
      totalBorrowed: totalBorrowed,
      totalOutstanding: totalOutstanding,
      totalPaid: totalBorrowed - totalOutstanding,
      monthlyEmi: monthlyEmi,
      activeLoans: activeLoans,
      closedLoans: closedLoans,
    );
  });
}
  Future<AnalyticsData> getAnalytics() async {
    final loans = await getLoans();

    double totalBorrowed = 0;
    double totalOutstanding = 0;
    double monthlyEmi = 0;

    int activeLoans = 0;
    int closedLoans = 0;

    for (final loan in loans) {
      totalBorrowed += loan.totalAmount;
      totalOutstanding += loan.outstandingAmount;
      monthlyEmi += loan.emiAmount;

      if (loan.isClosed) {
        closedLoans++;
      } else {
        activeLoans++;
      }
    }

    final totalPaid = totalBorrowed - totalOutstanding;

    return AnalyticsData(
      totalBorrowed: totalBorrowed,
      totalOutstanding: totalOutstanding,
      totalPaid: totalPaid,
      monthlyEmi: monthlyEmi,
      activeLoans: activeLoans,
      closedLoans: closedLoans,
    );
  }

  final AppDatabase database;

  LoanRepository(this.database);

  Future<int> addLoan(LoansCompanion loan) {
    return database.into(database.loans).insert(loan);
  }

  Future<List<Loan>> getLoans() {
    return database.select(database.loans).get();
  }

  Stream<List<Loan>> watchLoans() {
    return database.select(database.loans).watch();
  }

  Future<Loan?> getLoan(int id) {
    return (database.select(
      database.loans,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateLoan(Loan loan) async {
    await database.update(database.loans).replace(loan);
  }

  Future<int> deleteLoan(int id) {
    return (database.delete(
      database.loans,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateOutstandingBalance({
    required int loanId,
    required double paymentAmount,
  }) async {
    final loan = await getLoan(loanId);

    if (loan == null) return;

    double newOutstanding = loan.outstandingAmount - paymentAmount;

    if (newOutstanding < 0) {
      newOutstanding = 0;
    }

    final updatedLoan = loan.copyWith(
      outstandingAmount: newOutstanding,
      isClosed: newOutstanding == 0,
    );

    await updateLoan(updatedLoan);
    if (newOutstanding == 0) {
      await NotificationService.instance.cancelReminder(loanId);
    }
  }

  /// -------------------------
  /// PAYMENT METHODS
  /// -------------------------

  Future<int> addPayment(PaymentsCompanion payment) {
    return database.into(database.payments).insert(payment);
  }

  Future<List<Payment>> getPayments(int loanId) {
    return (database.select(database.payments)
          ..where((tbl) => tbl.loanId.equals(loanId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.paymentDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  Stream<List<Payment>> watchPayments(int loanId) {
    return (database.select(database.payments)
          ..where((tbl) => tbl.loanId.equals(loanId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.paymentDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Future<void> deleteLoanWithPayments(int loanId) async {
    await database.transaction(() async {
      await (database.delete(
        database.payments,
      )..where((tbl) => tbl.loanId.equals(loanId))).go();

      await (database.delete(
        database.loans,
      )..where((tbl) => tbl.id.equals(loanId))).go();
    });
  }

  Future<void> markEmiPaid({
    required int loanId,
    required double amount,
    String? remarks,
  }) async {
    await database.transaction(() async {
      await addPayment(
        PaymentsCompanion.insert(
          loanId: loanId,
          amount: amount,
          paymentDate: DateTime.now(),
          emiForMonth: DateTime.now(),
          remarks: Value(remarks),
        ),
      );

      await updateOutstandingBalance(loanId: loanId, paymentAmount: amount);
    });
  }
}
