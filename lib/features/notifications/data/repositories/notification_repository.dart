import 'package:loan_buddy/core/currency/app_currency.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class NotificationRepository {
  NotificationRepository(this._service, this._currency);

  final NotificationService _service;
  final AppCurrency _currency;

  Future<void> scheduleLoanReminder(Loan loan) async {
    if (!loan.reminderEnabled || loan.isClosed) {
      return;
    }

    await _service.scheduleMonthlyReminder(
      id: loan.id,
      loanName: loan.name,
      formattedEmiAmount: CurrencyFormatter.compact(loan.emiAmount, _currency),
      dueDay: loan.dueDay,
      reminderDaysBefore: loan.reminderDaysBefore,
      reminderTime: loan.reminderTime,
    );
  }

  Future<void> cancelLoanReminder(int loanId) {
    return _service.cancelReminder(loanId);
  }

  Future<void> cancelAllReminders() {
    return _service.cancelAll();
  }

  Future<void> rescheduleAllLoans(List<Loan> loans) async {
    await cancelAllReminders();

    for (final loan in loans) {
      if (!loan.reminderEnabled || loan.isClosed) continue;

      await scheduleLoanReminder(loan);
    }
  }
}
