import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/analytics/models/debt_forecast.dart';

class DebtForecastCard extends ConsumerWidget {
  final DebtForecast forecast;

  const DebtForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

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
                DateFormat('MMMM yyyy').format(
                  forecast.estimatedDebtFreeDate,
                ),
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
                CurrencyFormatter.format(
                  forecast.remainingPrincipal,
                  currency,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Current Monthly EMI'),
              trailing: Text(
                CurrencyFormatter.format(
                  forecast.remainingMonthlyEmi,
                  currency,
                ),
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