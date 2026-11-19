import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/services/repayment_strategy.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/payoff/models/payoff_simulation_result.dart';
import 'package:loan_buddy/features/payoff/models/payoff_summary.dart';

class PayoffSimulator {
  const PayoffSimulator._();

  static PayoffSimulationResult simulate({
    required List<Loan> loans,
    required RepaymentStrategy strategy,
    required double extraEmi,
  }) {
    final baseline = _calculateScenario(loans, strategy: strategy, extraEmi: 0);

    final simulated = _calculateScenario(
      loans,
      strategy: strategy,
      extraEmi: extraEmi,
    );

    final totalPrincipal = loans
        .where((loan) => !loan.isClosed)
        .fold<double>(0, (sum, loan) => sum + loan.outstandingAmount);

    return PayoffSimulationResult(
      strategy: strategy.type,
      debtFreeDate: _addMonths(DateTime.now(), simulated.months),
      totalInterest: simulated.interest,
      totalPrincipal: totalPrincipal,
      months: simulated.months,
      interestSaved: baseline.interest - simulated.interest,
      monthsSaved: baseline.months - simulated.months,
    );
  }

  static PayoffSummary _calculateScenario(
    List<Loan> loans, {
    required RepaymentStrategy strategy,
    required double extraEmi,
  }) {
    if (!extraEmi.isFinite || extraEmi < 0) {
      throw ArgumentError.value(extraEmi, 'extraEmi', 'Cannot be negative');
    }

    final balances = loans
        .where((loan) => !loan.isClosed && loan.outstandingAmount > 0)
        .map(_SimulatedLoan.new)
        .toList();

    if (balances.isEmpty) {
      return const PayoffSummary(interest: 0, months: 0);
    }

    final monthlyBudget =
        balances.fold<double>(0, (sum, loan) => sum + loan.minimumPayment) +
        extraEmi;

    var totalInterest = 0.0;
    var months = 0;

    while (balances.any((loan) => !loan.isPaidOff)) {
      months++;
      if (months > 1200) {
        throw StateError('The selected payments cannot repay these loans.');
      }

      final active = balances.where((loan) => !loan.isPaidOff).toList();
      for (final loan in active) {
        final interest = loan.balance * loan.monthlyRate;
        loan.balance += interest;
        totalInterest += interest;
      }

      var remainingBudget = monthlyBudget;
      for (final loan in active) {
        final payment = loan.minimumPayment.clamp(0.0, loan.balance);
        loan.balance -= payment;
        remainingBudget -= payment;
      }

      while (remainingBudget > 0.005) {
        final candidates = balances.where((loan) => !loan.isPaidOff).toList();
        if (candidates.isEmpty) break;

        final target = _selectTarget(candidates, strategy.type);
        final payment = remainingBudget.clamp(0.0, target.balance);
        target.balance -= payment;
        remainingBudget -= payment;
      }
    }

    return PayoffSummary(interest: totalInterest, months: months);
  }

  static _SimulatedLoan _selectTarget(
    List<_SimulatedLoan> loans,
    RepaymentStrategyType strategy,
  ) {
    loans.sort((a, b) {
      switch (strategy) {
        case RepaymentStrategyType.snowball:
          return a.balance.compareTo(b.balance);
        case RepaymentStrategyType.lowestEmi:
          return a.minimumPayment.compareTo(b.minimumPayment);
        case RepaymentStrategyType.earliestFinish:
          return (a.balance / a.minimumPayment).compareTo(
            b.balance / b.minimumPayment,
          );
        case RepaymentStrategyType.smart:
          final aCost = a.balance * a.monthlyRate;
          final bCost = b.balance * b.monthlyRate;
          return bCost.compareTo(aCost);
        case RepaymentStrategyType.avalanche:
          return b.monthlyRate.compareTo(a.monthlyRate);
      }
    });
    return loans.first;
  }

  static DateTime _addMonths(DateTime date, int months) {
    return DateTime(date.year, date.month + months, 1);
  }
}

class _SimulatedLoan {
  _SimulatedLoan(Loan loan)
    : balance = loan.outstandingAmount,
      monthlyRate = loan.interestRate / 100 / 12,
      minimumPayment = loan.emiAmount {
    if (minimumPayment <= balance * monthlyRate) {
      throw StateError('${loan.name} EMI is too low to repay the loan.');
    }
  }

  double balance;
  final double monthlyRate;
  final double minimumPayment;
  bool get isPaidOff => balance <= 0.005;
}
