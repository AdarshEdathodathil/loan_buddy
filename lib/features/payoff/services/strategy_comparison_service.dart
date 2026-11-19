import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy_factory.dart';
import 'package:loan_buddy/features/payoff/models/strategy_comparison.dart';
import 'package:loan_buddy/features/payoff/services/payoff_simulator.dart';

class StrategyComparisonService {
  const StrategyComparisonService._();

  static StrategyComparison compare(List<Loan> loans, double extraEmi) {
    final results = RepaymentStrategyType.values.map((type) {
      return PayoffSimulator.simulate(
        loans: loans,
        strategy: RepaymentStrategyFactory.get(type),
        extraEmi: extraEmi,
      );
    }).toList();

    return StrategyComparison(results: results);
  }
}
