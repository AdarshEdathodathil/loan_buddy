class DebtSummary {
  final double totalLoanAmount;
  final double outstandingAmount;
  final double totalPaidAmount;
  final double repaymentProgress;

  const DebtSummary({
    required this.totalLoanAmount,
    required this.outstandingAmount,
    required this.totalPaidAmount,
    required this.repaymentProgress,
  });
}