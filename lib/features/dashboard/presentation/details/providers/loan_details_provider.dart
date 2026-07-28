import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final loanDetailsProvider =
    FutureProvider.family((ref, int loanId) async {
  final repository = ref.watch(loanRepositoryProvider);

  final loans = await repository.getLoans();

  return loans.firstWhere((loan) => loan.id == loanId);
});