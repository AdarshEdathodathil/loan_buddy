import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final loanListProvider = StreamProvider<List<Loan>>((ref) {
  final repository = ref.watch(loanRepositoryProvider);
  return repository.watchLoans();
});