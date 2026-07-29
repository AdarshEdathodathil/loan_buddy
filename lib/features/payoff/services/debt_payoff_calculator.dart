import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/payoff/models/debt_payoff_result.dart';
import 'package:loan_buddy/features/payoff/services/amortization_engine.dart';

class DebtPayoffCalculator {
  const DebtPayoffCalculator._();

  static DebtPayoffResult calculate(
    List<Loan> loans, {
    double extraEmi = 0,
  }) {
    final activeLoans = loans.where((loan) => !loan.isClosed);

    double remainingPrincipal = 0;
    double totalInterest = 0;
    int longestSchedule = 0;

    for (final loan in activeLoans) {
      remainingPrincipal += loan.outstandingAmount;

      final schedule = AmortizationEngine.generateSchedule(
        loan,
        extraEmi: extraEmi,
      );

      totalInterest += schedule.fold(
        0,
        (sum, payment) => sum + payment.interestPaid,
      );

      if (schedule.length > longestSchedule) {
        longestSchedule = schedule.length;
      }
    }

    return DebtPayoffResult(
      remainingPrincipal: remainingPrincipal,
      estimatedInterestRemaining: totalInterest,
      remainingMonths: longestSchedule,
      debtFreeDate: DateTime.now().add(
        Duration(days: longestSchedule * 30),
      ),
    );
  }
}