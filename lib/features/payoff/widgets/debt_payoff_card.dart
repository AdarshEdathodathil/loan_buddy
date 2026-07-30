import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/payoff/models/debt_payoff_result.dart';

class DebtPayoffCard extends ConsumerWidget {
  final DebtPayoffResult result;

  const DebtPayoffCard({
    super.key,
    required this.result,
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
            Text(
              'Debt Payoff Planner',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Remaining Principal'),
              trailing: Text(
                CurrencyFormatter.format(
                  result.remainingPrincipal,
                  currency,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Estimated Interest'),
              trailing: Text(
                CurrencyFormatter.format(
                  result.estimatedInterestRemaining,
                  currency,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Debt-Free Date'),
              trailing: Text(
                DateFormat('dd MMM yyyy').format(
                  result.debtFreeDate,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Remaining Months'),
              trailing: Text(
                '${result.remainingMonths}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}