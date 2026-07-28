import 'package:loan_buddy/features/loans/data/models/loan_type.dart';

class AddLoanState {
  final int currentStep;

  final String loanName;
  final String lender;
  final LoanType loanType;

  final double totalAmount;
  final double outstandingAmount;
  final double interestRate;

  final double emiAmount;
  final int dueDay;

  final DateTime? startDate;
  final DateTime? endDate;

  final String notes;

  final bool reminderEnabled;
  final int reminderDaysBefore;
  final String reminderTime;

  const AddLoanState({
    this.currentStep = 0,
    this.loanName = '',
    this.lender = '',
    this.loanType = LoanType.personal,
    this.totalAmount = 0,
    this.outstandingAmount = 0,
    this.interestRate = 0,
    this.emiAmount = 0,
    this.dueDay = 1,
    this.startDate,
    this.endDate,
    this.notes = '',
    this.reminderEnabled = true,
    this.reminderDaysBefore = 1,
    this.reminderTime = '09:00',
  });

  AddLoanState copyWith({
    int? currentStep,
    String? loanName,
    String? lender,
    LoanType? loanType,
    double? totalAmount,
    double? outstandingAmount,
    double? interestRate,
    double? emiAmount,
    int? dueDay,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? reminderEnabled,
    int? reminderDaysBefore,
    String? reminderTime,
  }) {
    return AddLoanState(
      currentStep: currentStep ?? this.currentStep,
      loanName: loanName ?? this.loanName,
      lender: lender ?? this.lender,
      loanType: loanType ?? this.loanType,
      totalAmount: totalAmount ?? this.totalAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      interestRate: interestRate ?? this.interestRate,
      emiAmount: emiAmount ?? this.emiAmount,
      dueDay: dueDay ?? this.dueDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,

      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,

      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
