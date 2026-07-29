import 'package:loan_buddy/features/payoff/models/payoff_simulation_result.dart';

class StrategyComparison {
  final List<PayoffSimulationResult> results;

  const StrategyComparison({
    required this.results,
  });

  PayoffSimulationResult get bestInterest =>
      results.reduce(
        (a, b) =>
            a.totalInterest < b.totalInterest ? a : b,
      );

  PayoffSimulationResult get fastest =>
      results.reduce(
        (a, b) =>
            a.months < b.months ? a : b,
      );
}