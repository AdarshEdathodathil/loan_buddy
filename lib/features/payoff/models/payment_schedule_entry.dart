class PaymentScheduleEntry {
  final int month;
  final DateTime date;

  final double openingBalance;
  final double emi;
  final double principalPaid;
  final double interestPaid;
  final double closingBalance;

  const PaymentScheduleEntry({
    required this.month,
    required this.date,
    required this.openingBalance,
    required this.emi,
    required this.principalPaid,
    required this.interestPaid,
    required this.closingBalance,
  });
}