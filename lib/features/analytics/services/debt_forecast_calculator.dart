import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/analytics/models/debt_forecast.dart';

class DebtForecastCalculator {
  static DebtForecast calculate(AnalyticsData data) {
    if (data.monthlyEmi <= 0) {
      return DebtForecast(
        estimatedDebtFreeDate: DateTime.now(),
        remainingEmis: 0,
        remainingPrincipal: data.totalOutstanding,
        remainingMonthlyEmi: data.monthlyEmi,
      );
    }

    final remainingEmis =
        (data.totalOutstanding / data.monthlyEmi).ceil();

    final estimatedDebtFreeDate = DateTime(
      DateTime.now().year,
      DateTime.now().month + remainingEmis,
      DateTime.now().day,
    );

    return DebtForecast(
      estimatedDebtFreeDate: estimatedDebtFreeDate,
      remainingEmis: remainingEmis,
      remainingPrincipal: data.totalOutstanding,
      remainingMonthlyEmi: data.monthlyEmi,
    );
  }
}