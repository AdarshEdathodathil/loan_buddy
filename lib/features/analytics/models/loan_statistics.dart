class LoanStatistics {
  final double maxInterestRate;
  final double maxOutstandingAmount;
  final double maxEmiAmount;
  final double maxRemainingMonths;

  const LoanStatistics({
    required this.maxInterestRate,
    required this.maxOutstandingAmount,
    required this.maxEmiAmount,
    required this.maxRemainingMonths,
  });
}