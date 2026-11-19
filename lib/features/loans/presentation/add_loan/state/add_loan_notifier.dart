import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/app_currency.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/money/money_math.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/loans/data/models/loan_type.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';

import 'add_loan_state.dart';

class AddLoanNotifier extends StateNotifier<AddLoanState> {
  final LoanRepository repository;
  final AppCurrency currency;

  AddLoanNotifier(this.repository, this.currency) : super(const AddLoanState());

  String? validateBasicInfo() {
    if (state.loanName.trim().isEmpty) return 'Enter a loan name.';
    if (state.lender.trim().isEmpty) return 'Enter the lender name.';
    return null;
  }

  String? validateLoanDetails() {
    if (!state.totalAmount.isFinite || state.totalAmount <= 0) {
      return 'Enter a valid total loan amount.';
    }
    if (!state.outstandingAmount.isFinite || state.outstandingAmount <= 0) {
      return 'Enter a valid outstanding amount.';
    }
    if (state.outstandingAmount > state.totalAmount) {
      return 'Outstanding amount cannot exceed the total amount.';
    }
    if (!state.interestRate.isFinite ||
        state.interestRate < 0 ||
        state.interestRate > 100) {
      return 'Interest rate must be between 0 and 100.';
    }
    return null;
  }

  String? validateEmiDetails() {
    if (!state.emiAmount.isFinite || state.emiAmount <= 0) {
      return 'Enter a valid monthly EMI.';
    }
    if (state.dueDay < 1 || state.dueDay > 31) {
      return 'Due day must be between 1 and 31.';
    }
    if (state.startDate == null || state.endDate == null) {
      return 'Select both the start and end dates.';
    }
    if (!state.endDate!.isAfter(state.startDate!)) {
      return 'End date must be after the start date.';
    }

    final monthlyInterest =
        state.outstandingAmount * (state.interestRate / 100 / 12);
    if (state.emiAmount <= monthlyInterest) {
      return 'EMI must be greater than the monthly interest.';
    }
    return null;
  }

  String? validateAll() =>
      validateBasicInfo() ?? validateLoanDetails() ?? validateEmiDetails();

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep == 0) return;

    state = state.copyWith(currentStep: state.currentStep - 1);
  }

  void updateLoanName(String value) {
    state = state.copyWith(loanName: value);
  }

  void updateLender(String value) {
    state = state.copyWith(lender: value);
  }

  void updateLoanType(LoanType value) {
    state = state.copyWith(loanType: value);
  }

  void updateTotalAmount(double value) {
    state = state.copyWith(totalAmount: value);
  }

  void updateOutstanding(double value) {
    state = state.copyWith(outstandingAmount: value);
  }

  void updateInterest(double value) {
    state = state.copyWith(interestRate: value);
  }

  void updateEmi(double value) {
    state = state.copyWith(emiAmount: value);
  }

  void updateDueDay(int value) {
    state = state.copyWith(dueDay: value);
  }

  void updateStartDate(DateTime value) {
    state = state.copyWith(startDate: value);
  }

  void updateEndDate(DateTime value) {
    state = state.copyWith(endDate: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void updateReminderEnabled(bool value) {
    state = state.copyWith(reminderEnabled: value);
  }

  void loadLoan(Loan loan) {
    state = state.copyWith(
      loanName: loan.name,
      lender: loan.lender,
      loanType: LoanType.values[loan.loanType],
      totalAmount: loan.totalAmount,
      outstandingAmount: loan.outstandingAmount,
      interestRate: loan.interestRate,
      emiAmount: loan.emiAmount,
      dueDay: loan.dueDay,
      startDate: loan.startDate,
      endDate: loan.endDate,
      notes: loan.notes ?? '',
      reminderEnabled: loan.reminderEnabled,
      reminderDaysBefore: loan.reminderDaysBefore,
      reminderTime: loan.reminderTime,
    );
  }

  Future<void> saveLoan() async {
    final validationError = validateAll();
    if (validationError != null) throw StateError(validationError);

    final loan = LoansCompanion.insert(
      name: state.loanName.trim(),
      lender: state.lender.trim(),
      loanType: state.loanType.index,
      totalAmount: MoneyMath.normalize(state.totalAmount),
      outstandingAmount: MoneyMath.normalize(state.outstandingAmount),
      interestRate: state.interestRate,
      emiAmount: MoneyMath.normalize(state.emiAmount),
      dueDay: state.dueDay,
      startDate: state.startDate ?? DateTime.now(),
      endDate: state.endDate ?? DateTime.now(),
      notes: Value(state.notes.isEmpty ? null : state.notes),
      reminderEnabled: Value(state.reminderEnabled),
      reminderDaysBefore: Value(state.reminderDaysBefore),
      reminderTime: Value(state.reminderTime),
    );

    final loanId = await repository.addLoan(loan);

    final formattedEmiAmount = CurrencyFormatter.compact(
      state.emiAmount,
      currency,
    );

    if (state.reminderEnabled) {
      await NotificationService.instance.scheduleMonthlyReminder(
        id: loanId,
        loanName: state.loanName,
        formattedEmiAmount: formattedEmiAmount,
        dueDay: state.dueDay,
        reminderDaysBefore: state.reminderDaysBefore,
        reminderTime: state.reminderTime,
      );
    }
  }

  Future<void> updateLoan(Loan existingLoan) async {
    final validationError = validateAll();
    if (validationError != null) throw StateError(validationError);

    final updatedLoan = existingLoan.copyWith(
      name: state.loanName.trim(),
      lender: state.lender.trim(),
      loanType: state.loanType.index,
      totalAmount: MoneyMath.normalize(state.totalAmount),
      outstandingAmount: MoneyMath.normalize(state.outstandingAmount),
      interestRate: state.interestRate,
      emiAmount: MoneyMath.normalize(state.emiAmount),
      dueDay: state.dueDay,
      startDate: state.startDate ?? existingLoan.startDate,
      endDate: state.endDate ?? existingLoan.endDate,
      notes: Value(state.notes.isEmpty ? null : state.notes),
      reminderEnabled: state.reminderEnabled,
      reminderDaysBefore: state.reminderDaysBefore,
      reminderTime: state.reminderTime,
    );

    await repository.updateLoan(updatedLoan);

    await NotificationService.instance.cancelReminder(existingLoan.id);

    final formattedEmiAmount = CurrencyFormatter.compact(
      state.emiAmount,
      currency,
    );

    if (state.reminderEnabled && !existingLoan.isClosed) {
      await NotificationService.instance.scheduleMonthlyReminder(
        id: existingLoan.id,
        loanName: state.loanName,
        formattedEmiAmount: formattedEmiAmount,
        dueDay: state.dueDay,
        reminderDaysBefore: state.reminderDaysBefore,
        reminderTime: state.reminderTime,
      );
    }
  }
}
