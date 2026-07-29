import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';

abstract class RepaymentStrategy {
  const RepaymentStrategy();

  String get id;

  String get name;

  String get description;

  RepaymentAdvice? generate(List<Loan> loans);
}