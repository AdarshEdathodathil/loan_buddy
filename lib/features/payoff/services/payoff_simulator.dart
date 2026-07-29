import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/payoff/models/payoff_simulation_result.dart';
import 'package:loan_buddy/features/payoff/models/payoff_summary.dart';
import 'package:loan_buddy/features/payoff/services/amortization_engine.dart';

class PayoffSimulator {
  const PayoffSimulator._();

  static PayoffSimulationResult simulate({
    required List<Loan> loans,
    required RepaymentStrategy strategy,
    required double extraEmi,
  }) {
    final baseline = _calculateScenario(
      loans,
      extraEmi: 0,
    );

    final simulated = _calculateScenario(
      loans,
      extraEmi: extraEmi,
    );

    final totalPrincipal = loans
    .where((loan) => !loan.isClosed)
    .fold<double>(
      0,
      (sum, loan) => sum + loan.outstandingAmount,
    );

    return PayoffSimulationResult(
  strategy: strategy.type,
  debtFreeDate: DateTime.now().add(
    Duration(days: simulated.months * 30),
  ),
  totalInterest: simulated.interest,
  totalPrincipal: totalPrincipal,
  months: simulated.months,
  interestSaved: baseline.interest - simulated.interest,
  monthsSaved: baseline.months - simulated.months,
);
  }

  static PayoffSummary _calculateScenario(
  List<Loan> loans, {
  required double extraEmi,
}) {
  double totalInterest = 0;
  int longestMonths = 0;

  for (final loan in loans.where((loan) => !loan.isClosed)) {
    final schedule = AmortizationEngine.generateSchedule(
      loan,
      extraEmi: extraEmi,
    );

    final interest = schedule.fold<double>(
      0,
      (sum, payment) => sum + payment.interestPaid,
    );

    totalInterest += interest;

    if (schedule.length > longestMonths) {
      longestMonths = schedule.length;
    }
  }

  return PayoffSummary(
    interest: totalInterest,
    months: longestMonths,
  );
}
}