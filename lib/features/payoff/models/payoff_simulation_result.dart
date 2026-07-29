
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';

class PayoffSimulationResult {
  final RepaymentStrategyType strategy;

  final DateTime debtFreeDate;

  final double totalInterest;

  final double totalPrincipal;

  final int months;

  final double interestSaved;

  final int monthsSaved;

  const PayoffSimulationResult({
    required this.strategy,
    required this.debtFreeDate,
    required this.totalInterest,
    required this.totalPrincipal,
    required this.months,
    required this.interestSaved,
    required this.monthsSaved,
  });
}