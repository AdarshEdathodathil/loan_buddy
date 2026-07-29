class LoanSummary {
  final int activeLoans;
  final int closedLoans;
  final double averageEmi;

  const LoanSummary({
    required this.activeLoans,
    required this.closedLoans,
    required this.averageEmi,
  });
}