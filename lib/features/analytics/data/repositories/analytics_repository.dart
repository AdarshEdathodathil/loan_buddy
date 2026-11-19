import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';
import 'package:loan_buddy/features/analytics/models/analytics_dashboard_data.dart';

class AnalyticsRepository {
  final LoanRepository _loanRepository;

  AnalyticsRepository(this._loanRepository);

  Future<AnalyticsData> getAnalyticsData() async {
    final loans = await _loanRepository.getLoans();

    return calculateAnalytics(loans);
  }

  AnalyticsData calculateAnalytics(List<Loan> loans) {
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
        .fold<double>(0, (sum, loan) => sum + loan.emiAmount);

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

  Future<AnalyticsDashboardData> getDashboardData(
    RepaymentStrategy strategy,
  ) async {
    final loans = await _loanRepository.getLoans();

    return calculateDashboardData(loans, strategy);
  }

  AnalyticsDashboardData calculateDashboardData(
    List<Loan> loans,
    RepaymentStrategy strategy,
  ) {
    final analytics = calculateAnalytics(loans);

    final advice = strategy.generate(loans);

    return AnalyticsDashboardData(
      analytics: analytics,
      repaymentAdvice: advice,
    );
  }
}
