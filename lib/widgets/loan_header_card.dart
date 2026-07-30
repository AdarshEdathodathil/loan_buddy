import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class LoanHeaderCard extends ConsumerWidget {
  final String loanName;
  final String lender;
  final double totalAmount;
  final double outstandingAmount;

  const LoanHeaderCard({
    super.key,
    required this.loanName,
    required this.lender,
    required this.totalAmount,
    required this.outstandingAmount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final paid = totalAmount - outstandingAmount;

    final progress = totalAmount == 0
        ? 0.0
        : (paid / totalAmount).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loanName, style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 4),

            Text(lender, style: TextStyle(color: Colors.grey.shade600)),

            const SizedBox(height: 20),

            const Text("Outstanding Balance"),

            const SizedBox(height: 8),

            Text(
              CurrencyFormatter.compact(outstandingAmount, currency),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Paid ${CurrencyFormatter.compact(paid, currency)}"),
                Text("Total ${CurrencyFormatter.compact(totalAmount, currency)}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
