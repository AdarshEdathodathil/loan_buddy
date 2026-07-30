import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:loan_buddy/features/analytics/models/analytics_data.dart';
import 'package:loan_buddy/features/analytics/providers/extra_emi_provider.dart';
import 'package:loan_buddy/features/analytics/services/extra_emi_calculator.dart';

class ExtraEmiSimulator extends ConsumerWidget {
  final AnalyticsData analytics;

  const ExtraEmiSimulator({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraEmi = ref.watch(extraEmiProvider);

    final result = ExtraEmiCalculator.calculate(
      data: analytics,
      extraEmi: extraEmi,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Extra EMI Simulator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Extra EMI: ${extraEmi.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            Slider(
              min: 500,
              max: 20000,
              divisions: 39,
              value: extraEmi,
              onChanged: (value) {
                ref.read(extraEmiProvider.notifier).state = value;
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Current Debt-Free Date'),
              trailing: Text(
                DateFormat('MMM yyyy')
                    .format(result.currentDebtFreeDate),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.auto_graph),
              title: const Text('New Debt-Free Date'),
              trailing: Text(
                DateFormat('MMM yyyy')
                    .format(result.newDebtFreeDate),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Months Saved'),
              trailing: Text(
                '${result.monthsSaved}',
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