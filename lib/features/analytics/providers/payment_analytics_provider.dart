import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/payments/providers/payment_provider.dart';
import 'package:loan_buddy/features/analytics/models/monthly_emi_data.dart';

final monthlyEmiTrendProvider = Provider<AsyncValue<List<MonthlyEmiData>>>((
  ref,
) {
  final repo = ref.watch(paymentRepositoryProvider);
  final payments = ref.watch(allPaymentsProvider);
  return payments.whenData(repo.calculateMonthlyEmiTrend);
});
