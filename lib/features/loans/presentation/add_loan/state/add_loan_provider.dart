import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/loan_provider.dart';
import 'add_loan_notifier.dart';
import 'add_loan_state.dart';

final addLoanProvider =
    StateNotifierProvider<AddLoanNotifier, AddLoanState>((ref) {
  final repository = ref.watch(loanRepositoryProvider);
  return AddLoanNotifier(repository);
});