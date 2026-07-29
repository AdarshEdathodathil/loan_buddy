import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/avalanche_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/earliest_finish_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/lowest_emi_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/smart_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/snowball_strategy.dart';

class RepaymentStrategyFactory {
  const RepaymentStrategyFactory._();

  static RepaymentStrategy get(
    RepaymentStrategyType type,
  ) {
    switch (type) {
      case RepaymentStrategyType.smart:
        return const SmartStrategy();

      case RepaymentStrategyType.snowball:
        return const SnowballStrategy();

      case RepaymentStrategyType.avalanche:
        return const AvalancheStrategy();

      case RepaymentStrategyType.lowestEmi:
        return const LowestEMIStrategy();

      case RepaymentStrategyType.earliestFinish:
        return const EarliestFinishStrategy();
    }
  }
}