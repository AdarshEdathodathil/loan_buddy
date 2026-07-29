import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/providers/repayment_strategy_provider.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy_factory.dart';

final repaymentStrategyServiceProvider =
    Provider<RepaymentStrategy>((ref) {
  final type = ref.watch(repaymentStrategyProvider);

  return RepaymentStrategyFactory.get(type);
});