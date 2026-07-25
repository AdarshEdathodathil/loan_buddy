import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';
import 'package:loan_buddy/features/loans/data/models/loan_type.dart';
import 'package:drift/drift.dart';
import 'package:loan_buddy/core/database/app_database.dart';


import 'add_loan_state.dart';

class AddLoanNotifier extends StateNotifier<AddLoanState> {
  final LoanRepository repository;

  AddLoanNotifier(this.repository) : super(const AddLoanState());

  void nextStep() {
    state = state.copyWith(
      currentStep: state.currentStep + 1,
    );
  }

  void previousStep() {
    if (state.currentStep == 0) return;

    state = state.copyWith(
      currentStep: state.currentStep - 1,
    );
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

Future<void> saveLoan() async {
  final loan = LoansCompanion.insert(
    name: state.loanName,
    lender: state.lender,
    loanType: state.loanType.index,
    totalAmount: state.totalAmount,
    outstandingAmount: state.totalAmount,
    interestRate: state.interestRate,
    emiAmount: state.emiAmount,
    dueDay: state.dueDay,
    startDate: state.startDate ?? DateTime.now(),
    endDate: state.endDate ?? DateTime.now(),
    notes: Value(
      state.notes.isEmpty ? null : state.notes,
    ),
  );

  await repository.addLoan(loan);
}
}