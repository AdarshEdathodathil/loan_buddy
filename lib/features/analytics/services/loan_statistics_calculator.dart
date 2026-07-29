import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/analytics/models/loan_statistics.dart';

class LoanStatisticsCalculator {
  static LoanStatistics calculate(List<Loan> loans) {
    final activeLoans = loans
        .where((loan) => !loan.isClosed && loan.outstandingAmount > 0)
        .toList();

    if (activeLoans.isEmpty) {
      return const LoanStatistics(
        maxInterestRate: 1,
        maxOutstandingAmount: 1,
        maxEmiAmount: 1,
        maxRemainingMonths: 1,
      );
    }

    double maxInterest = 0;
    double maxOutstanding = 0;
    double maxEmi = 0;
    double maxRemainingMonths = 0;

    for (final loan in activeLoans) {
      if (loan.interestRate > maxInterest) {
        maxInterest = loan.interestRate;
      }

      if (loan.outstandingAmount > maxOutstanding) {
        maxOutstanding = loan.outstandingAmount;
      }

      if (loan.emiAmount > maxEmi) {
        maxEmi = loan.emiAmount;
      }

      final remainingMonths =
          loan.endDate.difference(DateTime.now()).inDays / 30;

      if (remainingMonths > maxRemainingMonths) {
        maxRemainingMonths = remainingMonths;
      }
    }

    return LoanStatistics(
      maxInterestRate: maxInterest == 0 ? 1 : maxInterest,
      maxOutstandingAmount: maxOutstanding == 0 ? 1 : maxOutstanding,
      maxEmiAmount: maxEmi == 0 ? 1 : maxEmi,
      maxRemainingMonths:
          maxRemainingMonths <= 0 ? 1 : maxRemainingMonths,
    );
  }
}