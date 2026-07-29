class DebtPayoffResult {
  final double remainingPrincipal;
  final double estimatedInterestRemaining;
  final int remainingMonths;
  final DateTime debtFreeDate;

  const DebtPayoffResult({
    required this.remainingPrincipal,
    required this.estimatedInterestRemaining,
    required this.remainingMonths,
    required this.debtFreeDate,
  });
}