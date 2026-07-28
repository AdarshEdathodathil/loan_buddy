import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepaymentProgressCard extends StatelessWidget {
  const RepaymentProgressCard({
    super.key,
    required this.borrowed,
    required this.outstanding,
  });

  final double borrowed;
  final double outstanding;

  @override
  Widget build(BuildContext context) {
    final paid = borrowed - outstanding;

    final progress = borrowed == 0
        ? 0.0
        : (paid / borrowed).clamp(0.0, 1.0);

    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

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
              "Repayment Progress",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "${(progress * 100).toStringAsFixed(1)}%",
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _AmountCard(
                    title: "Paid",
                    value: currency.format(paid),
                    icon: Icons.check_circle_outline,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _AmountCard(
                    title: "Remaining",
                    value: currency.format(outstanding),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon),

          const SizedBox(height: 8),

          Text(title),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}