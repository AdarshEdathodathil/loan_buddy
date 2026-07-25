import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/database_provider.dart';
import 'package:loan_buddy/features/payments/data/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PaymentRepository(db);
});