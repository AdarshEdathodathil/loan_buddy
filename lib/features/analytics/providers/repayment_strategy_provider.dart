import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';

final repaymentStrategyProvider =
    StateProvider<RepaymentStrategyType>(
  (ref) => RepaymentStrategyType.smart,
);