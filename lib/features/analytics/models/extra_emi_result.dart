class ExtraEmiResult {
  final int currentMonths;
  final int newMonths;
  final int monthsSaved;

  final DateTime currentDebtFreeDate;
  final DateTime newDebtFreeDate;

  final double extraEmi;

  const ExtraEmiResult({
    required this.currentMonths,
    required this.newMonths,
    required this.monthsSaved,
    required this.currentDebtFreeDate,
    required this.newDebtFreeDate,
    required this.extraEmi,
  });
}