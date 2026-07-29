import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';

class AnalyticsDashboardData {
  final AnalyticsData analytics;
  final RepaymentAdvice? repaymentAdvice;

  const AnalyticsDashboardData({
    required this.analytics,
    this.repaymentAdvice,
  });
}