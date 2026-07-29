import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/analytics/services/smart_repayment_advisor.dart';

class SmartStrategy implements RepaymentStrategy {
  const SmartStrategy();

  @override
  String get id => 'smart';

  @override
  String get name => 'Smart';

  @override
  String get description =>
      'Balanced recommendation using multiple financial factors.';

  @override
  RepaymentAdvice? generate(List<Loan> loans) {
    return SmartRepaymentAdvisor.generate(loans);
  }
}