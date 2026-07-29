import 'package:loan_buddy/core/database/app_database.dart';

enum RepaymentPriority {
  low,
  medium,
  high,
}

class RepaymentAdvice {
  final Loan recommendedLoan;

  final String title;

  final String reason;

  final List<String> highlights;

  final double score;

  final RepaymentPriority priority;

  const RepaymentAdvice({
    required this.recommendedLoan,
    required this.title,
    required this.reason,
    required this.highlights,
    required this.score,
    required this.priority,
  });
}