import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final loanDetailsProvider =
    FutureProvider.family<Loan?, int>((ref, loanId) {
  final repository = ref.watch(loanRepositoryProvider);
  return repository.getLoan(loanId);
});