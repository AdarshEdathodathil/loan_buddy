import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/analytics/models/analytics_data.dart';

class InsightCards extends ConsumerWidget {
  final AnalyticsData data;

  const InsightCards({super.key, required this.data});

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        _buildCard(
          context,
          "Borrowed",
          CurrencyFormatter.compact(data.totalBorrowed, currency),
          Icons.account_balance_wallet,
        ),
        _buildCard(
          context,
          "Outstanding",
          CurrencyFormatter.compact(data.totalOutstanding, currency),
          Icons.warning_amber_rounded,
        ),
        _buildCard(
          context,
          "Paid",
          CurrencyFormatter.compact(data.totalPaid, currency),
          Icons.check_circle_outline,
        ),
        _buildCard(
          context,
          "Monthly EMI",
          CurrencyFormatter.compact(data.monthlyEmi, currency),
          Icons.calendar_month,
        ),
      ],
    );
  }
}
