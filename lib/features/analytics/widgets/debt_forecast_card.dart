import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/features/analytics/models/debt_forecast.dart';

class DebtForecastCard extends StatelessWidget {
  final DebtForecast forecast;

  const DebtForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debt-Free Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Estimated Debt-Free Date'),
              subtitle: Text(
                DateFormat('MMMM yyyy')
                    .format(forecast.estimatedDebtFreeDate),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Remaining EMIs'),
              trailing: Text(
                '${forecast.remainingEmis}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Remaining Principal'),
              trailing: Text(
                formatter.format(forecast.remainingPrincipal),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Current Monthly EMI'),
              trailing: Text(
                formatter.format(forecast.remainingMonthlyEmi),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}