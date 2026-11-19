import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';

import '../../../providers/loan_provider.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'add_loan_notifier.dart';
import 'add_loan_state.dart';

/// Overridden by [AddLoanScreen] so edit forms are initialized before their
/// TextFormFields are created.
final initialLoanProvider = Provider<Loan?>((ref) => null);

final addLoanProvider =
    StateNotifierProvider.autoDispose<AddLoanNotifier, AddLoanState>((ref) {
      final repository = ref.watch(loanRepositoryProvider);
      final currency = ref.read(currencyProvider);
      final notifier = AddLoanNotifier(repository, currency);
      final initialLoan = ref.watch(initialLoanProvider);
      if (initialLoan != null) notifier.loadLoan(initialLoan);
      return notifier;
    }, dependencies: [initialLoanProvider]);
