import 'package:loan_buddy/core/database/app_database.dart';

class SmartInsights {
  final Loan largestLoan;
  final Loan highestEmiLoan;
  final Loan? nextDueLoan;

  final int activeLoans;
  final int closedLoans;

  const SmartInsights({
    required this.largestLoan,
    required this.highestEmiLoan,
    required this.nextDueLoan,
    required this.activeLoans,
    required this.closedLoans,
  });
}