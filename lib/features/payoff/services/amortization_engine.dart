import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/payoff/models/payment_schedule_entry.dart';

class AmortizationEngine {
  const AmortizationEngine._();

  static List<PaymentScheduleEntry> generateSchedule(
    Loan loan, {
    double extraEmi = 0,
  }) {
    final schedule = <PaymentScheduleEntry>[];

    double balance = loan.outstandingAmount;
    final monthlyRate = loan.interestRate / 100 / 12;
    final emi = loan.emiAmount + extraEmi;

    int month = 1;
    DateTime paymentDate = DateTime.now();

    while (balance > 1) {
      final openingBalance = balance;

      final interest = openingBalance * monthlyRate;

      double principal = emi - interest;

      if (principal <= 0) {
        throw Exception(
          'EMI is too low to repay the loan.',
        );
      }

      if (principal > balance) {
        principal = balance;
      }

      balance -= principal;

      schedule.add(
        PaymentScheduleEntry(
          month: month,
          date: paymentDate,
          openingBalance: openingBalance,
          emi: principal + interest,
          principalPaid: principal,
          interestPaid: interest,
          closingBalance: balance < 0 ? 0 : balance,
        ),
      );

      month++;
      paymentDate = DateTime(
        paymentDate.year,
        paymentDate.month + 1,
        paymentDate.day,
      );
    }

    return schedule;
  }
}