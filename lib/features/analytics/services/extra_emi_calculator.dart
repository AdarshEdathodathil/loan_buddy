import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/analytics/models/extra_emi_result.dart';

class ExtraEmiCalculator {
  static ExtraEmiResult calculate({
    required AnalyticsData data,
    required double extraEmi,
  }) {
    final currentMonths =
        (data.totalOutstanding / data.monthlyEmi).ceil();

    final newMonthlyPayment =
        data.monthlyEmi + extraEmi;

    final newMonths =
        (data.totalOutstanding / newMonthlyPayment).ceil();

    final monthsSaved = currentMonths - newMonths;

    final now = DateTime.now();

    return ExtraEmiResult(
      currentMonths: currentMonths,
      newMonths: newMonths,
      monthsSaved: monthsSaved,
      currentDebtFreeDate: DateTime(
        now.year,
        now.month + currentMonths,
        now.day,
      ),
      newDebtFreeDate: DateTime(
        now.year,
        now.month + newMonths,
        now.day,
      ),
      extraEmi: extraEmi,
    );
  }
}