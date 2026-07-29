import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/data/repositories/analytics_repository.dart';
import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(
    ref.watch(loanRepositoryProvider),
  );
});

final analyticsProvider =
    FutureProvider<AnalyticsData>((ref) async {
  return ref.watch(analyticsRepositoryProvider).getAnalyticsData();
});