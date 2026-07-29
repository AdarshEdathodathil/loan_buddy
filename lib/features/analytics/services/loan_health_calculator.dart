import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/analytics/models/loan_health.dart';

class LoanHealthCalculator {
  static LoanHealth calculate(AnalyticsData data) {
    int score = 100;

    if (data.totalBorrowed > 0) {
      final repaymentRatio = data.totalPaid / data.totalBorrowed;
      score = (repaymentRatio * 100).round();
    }

    score = score.clamp(0, 100);

    String title;
    String description;

    if (score >= 80) {
      title = 'Excellent';
      description = 'Your loans are in very good shape.';
    } else if (score >= 60) {
      title = 'Good';
      description = 'Your repayment progress is healthy.';
    } else if (score >= 40) {
      title = 'Fair';
      description = 'Focus on reducing outstanding debt.';
    } else {
      title = 'Needs Attention';
      description = 'Your repayment progress is currently low.';
    }

    return LoanHealth(
      score: score,
      title: title,
      description: description,
    );
  }
}