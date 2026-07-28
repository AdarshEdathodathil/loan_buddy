import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/dashboard/models/analytics_data.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final analyticsProvider =
    StreamProvider<AnalyticsData>((ref) {
  final repository = ref.watch(loanRepositoryProvider);

  return repository.watchAnalytics();
});