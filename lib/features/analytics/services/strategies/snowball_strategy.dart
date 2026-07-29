import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';

class SnowballStrategy implements RepaymentStrategy {
  const SnowballStrategy();

 @override
RepaymentStrategyType get type => RepaymentStrategyType.snowball;

  @override
  String get name => 'Snowball';

  @override
  String get description =>
      'Pay off the smallest outstanding balance first.';

  @override
  RepaymentAdvice? generate(List<Loan> loans) {
    final activeLoans = loans.where((loan) => !loan.isClosed).toList();

    if (activeLoans.isEmpty) {
      return null;
    }

    activeLoans.sort(
      (a, b) => a.outstandingAmount.compareTo(b.outstandingAmount),
    );

    final loan = activeLoans.first;

    return RepaymentAdvice(
      recommendedLoan: loan,
      title: 'Snowball Strategy',
      reason:
          'Pay off the smallest balance first to build momentum and free up monthly cash flow.',

      highlights: [
        'Smallest outstanding balance',
        'Quickest loan to close',
        'Builds repayment motivation',
        'Creates financial momentum',
      ],

      score: 100,

      priority: RepaymentPriority.high,
    );
  }
}