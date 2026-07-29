import 'package:loan_buddy/core/database/app_database.dart';

class LoanScore {
  final Loan loan;
  final double score;

  const LoanScore({
    required this.loan,
    required this.score,
  });
}