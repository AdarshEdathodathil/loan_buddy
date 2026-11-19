import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/database_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/payments/data/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PaymentRepository(db);
});

final allPaymentsProvider = StreamProvider<List<Payment>>((ref) {
  return ref.watch(paymentRepositoryProvider).watchAllPayments();
});
