class DebtForecast {
  final DateTime estimatedDebtFreeDate;
  final int remainingEmis;
  final double remainingPrincipal;
  final double remainingMonthlyEmi;

  const DebtForecast({
    required this.estimatedDebtFreeDate,
    required this.remainingEmis,
    required this.remainingPrincipal,
    required this.remainingMonthlyEmi,
  });
}