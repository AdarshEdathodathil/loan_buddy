class AnalyticsStats {
  final double totalBorrowed;
  final double totalOutstanding;
  final double totalPaid;
  final double monthlyEmi;

  final int activeLoans;
  final int closedLoans;

  const AnalyticsStats({
    required this.totalBorrowed,
    required this.totalOutstanding,
    required this.totalPaid,
    required this.monthlyEmi,
    required this.activeLoans,
    required this.closedLoans,
  });
}