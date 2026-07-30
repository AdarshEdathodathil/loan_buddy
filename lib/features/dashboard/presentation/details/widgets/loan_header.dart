import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class LoanHeader extends ConsumerWidget {
  const LoanHeader({
    super.key,
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loan.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 6),

            Text(
              loan.lender,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 20),

            Text(
              "Outstanding",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 8),

            Text(
              CurrencyFormatter.format(
                loan.outstandingAmount,
                currency,
              ),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Chip(
              avatar: Icon(
                loan.isClosed
                    ? Icons.check_circle
                    : Icons.schedule,
                size: 18,
              ),
              label: Text(
                loan.isClosed ? "Closed" : "Active",
              ),
            ),
          ],
        ),
      ),
    );
  }
}