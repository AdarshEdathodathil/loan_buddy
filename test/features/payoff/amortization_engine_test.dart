import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/services/strategies/avalanche_strategy.dart';
import 'package:loan_buddy/features/analytics/services/strategies/snowball_strategy.dart';
import 'package:loan_buddy/features/payoff/services/amortization_engine.dart';
import 'package:loan_buddy/features/payoff/services/payoff_simulator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AmortizationEngine', () {
    test('handles a final payment smaller than the regular EMI', () {
      final schedule = AmortizationEngine.generateSchedule(
        _loan(outstanding: 1200, interestRate: 0, emi: 1000),
      );

      expect(schedule, hasLength(2));
      expect(schedule.last.principalPaid, 200);
      expect(schedule.last.closingBalance, 0);
    });

    test('rejects an EMI that does not cover monthly interest', () {
      expect(
        () => AmortizationEngine.generateSchedule(
          _loan(outstanding: 100000, interestRate: 12, emi: 500),
        ),
        throwsException,
      );
    });
  });

  group('PayoffSimulator', () {
    test('avalanche produces less interest than snowball', () {
      final loans = [
        _loan(
          id: 1,
          name: 'High interest',
          outstanding: 10000,
          interestRate: 24,
          emi: 500,
        ),
        _loan(
          id: 2,
          name: 'Small balance',
          outstanding: 3000,
          interestRate: 6,
          emi: 300,
        ),
      ];

      final avalanche = PayoffSimulator.simulate(
        loans: loans,
        strategy: const AvalancheStrategy(),
        extraEmi: 500,
      );
      final snowball = PayoffSimulator.simulate(
        loans: loans,
        strategy: const SnowballStrategy(),
        extraEmi: 500,
      );

      expect(avalanche.totalInterest, lessThan(snowball.totalInterest));
      expect(avalanche.totalPrincipal, 13000);
    });
  });
}

Loan _loan({
  int id = 1,
  String name = 'Test loan',
  required double outstanding,
  required double interestRate,
  required double emi,
}) {
  return Loan(
    id: id,
    name: name,
    lender: 'Test lender',
    loanType: 0,
    totalAmount: outstanding,
    outstandingAmount: outstanding,
    interestRate: interestRate,
    emiAmount: emi,
    dueDay: 1,
    startDate: DateTime(2026),
    endDate: DateTime(2036),
    reminderEnabled: false,
    reminderDaysBefore: 1,
    reminderTime: '09:00',
    isClosed: false,
  );
}
