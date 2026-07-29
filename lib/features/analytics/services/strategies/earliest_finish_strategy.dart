import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';

class EarliestFinishStrategy implements RepaymentStrategy {
  const EarliestFinishStrategy();

  @override
  RepaymentStrategyType get type => RepaymentStrategyType.earliestFinish;
  @override
  String get name => 'Earliest Finish';

  @override
  String get description => 'Pay off the loan that will be finished earliest.';

  @override
  RepaymentAdvice? generate(List<Loan> loans) {
    return null;
  }
}
