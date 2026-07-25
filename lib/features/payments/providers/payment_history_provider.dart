import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/payments/providers/payment_provider.dart';

final paymentHistoryProvider =
    StreamProvider.family<List<Payment>, int>((ref, loanId) {
  return ref.watch(paymentRepositoryProvider).watchPayments(loanId);
});