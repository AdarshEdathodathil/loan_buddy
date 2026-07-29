
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';

abstract class RepaymentStrategy {
  RepaymentStrategyType get type;

  String get name;

  String get description;

  RepaymentAdvice? generate(List<Loan> loans);
}