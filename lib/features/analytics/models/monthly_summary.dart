class MonthlySummary {
  final int paymentsThisMonth;
  final double amountPaidThisMonth;
  final int upcomingEmis;
  final int overdueEmis;

  const MonthlySummary({
    required this.paymentsThisMonth,
    required this.amountPaidThisMonth,
    required this.upcomingEmis,
    required this.overdueEmis,
  });
}