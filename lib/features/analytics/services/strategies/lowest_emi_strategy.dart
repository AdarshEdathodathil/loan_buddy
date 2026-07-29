import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';

class LowestEMIStrategy implements RepaymentStrategy {
  const LowestEMIStrategy();

  @override
  String get id => 'lowest_emi';

  @override
  String get name => 'Lowest EMI';

  @override
  String get description =>
      'Pay off the lowest emi first.';

  @override
  RepaymentAdvice? generate(List<Loan> loans) {
    return null;
  }
}