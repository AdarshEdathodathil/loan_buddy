import 'debt_summary.dart';
import 'loan_summary.dart';
import 'monthly_summary.dart';

class AnalyticsSummary {
  final DebtSummary debt;
  final LoanSummary loans;
  final MonthlySummary monthly;

  const AnalyticsSummary({
    required this.debt,
    required this.loans,
    required this.monthly,
  });
}