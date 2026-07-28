import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/payments/providers/payment_provider.dart';

final monthlyEmiTrendProvider =
    FutureProvider((ref) async {
  final repo = ref.watch(paymentRepositoryProvider);

  return repo.getMonthlyEmiTrend();
});