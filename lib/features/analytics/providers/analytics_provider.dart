import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/data/repositories/analytics_repository.dart';
import 'package:loan_buddy/features/analytics/models/analytics_dashboard_data.dart';
import 'package:loan_buddy/features/analytics/providers/repayment_strategy_service_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(loanRepositoryProvider));
});

final analyticsProvider = Provider<AsyncValue<AnalyticsDashboardData>>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  final strategy = ref.watch(repaymentStrategyServiceProvider);
  final loans = ref.watch(loanListProvider);

  return loans.whenData(
    (items) => repository.calculateDashboardData(items, strategy),
  );
});
