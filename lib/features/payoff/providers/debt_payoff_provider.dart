import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/payoff/models/debt_payoff_result.dart';
import 'package:loan_buddy/features/payoff/services/debt_payoff_calculator.dart';

final debtPayoffProvider =
    FutureProvider<DebtPayoffResult>((ref) async {
  final loanRepository = ref.watch(loanRepositoryProvider);
  final loans = await loanRepository.getLoans();

  return DebtPayoffCalculator.calculate(loans);
});