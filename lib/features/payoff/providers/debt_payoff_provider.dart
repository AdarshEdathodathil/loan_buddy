import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/payoff/models/debt_payoff_result.dart';
import 'package:loan_buddy/features/payoff/services/debt_payoff_calculator.dart';

final debtPayoffProvider = Provider<AsyncValue<DebtPayoffResult>>((ref) {
  final loans = ref.watch(loanListProvider);
  return loans.whenData(DebtPayoffCalculator.calculate);
});
