import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/loan_score.dart';
import 'package:loan_buddy/features/analytics/models/loan_statistics.dart';

class LoanScoreCalculator {
  static LoanScore calculate({
    required Loan loan,
    required LoanStatistics statistics,
  }) {
    // Normalize each factor between 0 and 1
    final interestScore =
        loan.interestRate / statistics.maxInterestRate;

    // Smaller outstanding balance = higher score
    final outstandingScore =
        1 - (loan.outstandingAmount / statistics.maxOutstandingAmount);

    final emiScore =
        loan.emiAmount / statistics.maxEmiAmount;

    final remainingMonths =
        loan.endDate.difference(DateTime.now()).inDays / 30;

    final tenureScore =
        remainingMonths / statistics.maxRemainingMonths;

    // Weighted score
    final totalScore =
        (interestScore * 40) +
        (outstandingScore * 25) +
        (emiScore * 20) +
        (tenureScore * 15);

    return LoanScore(
      loan: loan,
      score: totalScore,
    );
  }
}