import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/services/loan_score_calculator.dart';
import 'package:loan_buddy/features/analytics/services/loan_statistics_calculator.dart';

class SmartRepaymentAdvisor {
  static RepaymentAdvice? generate(List<Loan> loans) {
    final activeLoans = loans
        .where((loan) => !loan.isClosed && loan.outstandingAmount > 0)
        .toList();

    if (activeLoans.isEmpty) {
      return null;
    }

    final statistics =
        LoanStatisticsCalculator.calculate(activeLoans);

    final scores = activeLoans
        .map(
          (loan) => LoanScoreCalculator.calculate(
            loan: loan,
            statistics: statistics,
          ),
        )
        .toList();

    scores.sort((a, b) => b.score.compareTo(a.score));

    final best = scores.first;

    return RepaymentAdvice(
  recommendedLoan: best.loan,
  title: 'Recommended Loan to Close First',
  reason:
      'This loan provides the best balance between interest cost, monthly EMI reduction, and repayment efficiency.',

  score: best.score,

  highlights: [
  'Interest Rate: ${best.loan.interestRate.toStringAsFixed(2)}%',
  'Outstanding Balance: ${best.loan.outstandingAmount.toStringAsFixed(0)}',
  'Monthly EMI: ${best.loan.emiAmount.toStringAsFixed(0)}',
  'Closing this loan reduces one monthly EMI.',
],

  priority: RepaymentPriority.high,
);
  }
}