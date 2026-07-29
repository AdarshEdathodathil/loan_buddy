import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';

class AnalyticsRepository {
  final LoanRepository _loanRepository;

  AnalyticsRepository(this._loanRepository);

  Future<AnalyticsData> getAnalyticsData() async {
  final loans = await _loanRepository.getLoans();

  final totalBorrowed = loans.fold<double>(
    0,
    (sum, loan) => sum + loan.totalAmount,
  );

  final totalOutstanding = loans.fold<double>(
    0,
    (sum, loan) => sum + loan.outstandingAmount,
  );

  final totalPaid = totalBorrowed - totalOutstanding;

  final monthlyEmi = loans
    .where((loan) => !loan.isClosed && loan.outstandingAmount > 0)
    .fold<double>(
      0,
      (sum, loan) => sum + loan.emiAmount,
    );

  final activeLoans = loans.where((loan) => !loan.isClosed).length;

  final closedLoans = loans.where((loan) => loan.isClosed).length;

  return AnalyticsData(
    totalBorrowed: totalBorrowed,
    totalOutstanding: totalOutstanding,
    totalPaid: totalPaid,
    monthlyEmi: monthlyEmi,
    activeLoans: activeLoans,
    closedLoans: closedLoans,
  );
}



}
