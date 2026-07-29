import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';

class AvalancheStrategy implements RepaymentStrategy {
  const AvalancheStrategy();

  @override
  String get id => 'avalanche';

  @override
  String get name => 'Avalanche';

  @override
  String get description =>
      'Pay off the highest interest rate loan first.';

  @override
  RepaymentAdvice? generate(List<Loan> loans) {
    final activeLoans = loans.where((loan) => !loan.isClosed).toList();

    if (activeLoans.isEmpty) {
      return null;
    }

    activeLoans.sort(
      (a, b) => b.interestRate.compareTo(a.interestRate),
    );

    final loan = activeLoans.first;

    return RepaymentAdvice(
      recommendedLoan: loan,
      title: 'Avalanche Strategy',
      reason:
          'Paying off the highest interest loan first minimizes the total interest paid over time.',

      highlights: [
        'Highest interest rate: ${loan.interestRate.toStringAsFixed(2)}%',
        'Outstanding balance: ₹${loan.outstandingAmount.toStringAsFixed(0)}',
        'Most interest savings over time',
        'Mathematically optimal repayment strategy',
      ],

      score: 100,
      priority: RepaymentPriority.high,
    );
  }
}