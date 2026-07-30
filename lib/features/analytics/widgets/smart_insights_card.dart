import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/analytics/models/smart_insights.dart';

class SmartInsightsCard extends ConsumerWidget {
  const SmartInsightsCard({super.key, required this.insights});

  final SmartInsights insights;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.lightbulb_outline, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  "Smart Insights",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _InsightTile(
              icon: Icons.account_balance,
              iconColor: Colors.indigo,
              title: "Largest Loan",
              value: insights.largestLoan.name,
              subtitle: CurrencyFormatter.format(
                insights.largestLoan.totalAmount,
                currency,
              ),
            ),

            const Divider(height: 28),

            _InsightTile(
              icon: Icons.payments,
              iconColor: Colors.green,
              title: "Highest EMI",
              value: CurrencyFormatter.format(
                insights.highestEmiLoan.emiAmount,
                currency,
              ),
              subtitle: insights.highestEmiLoan.lender,
            ),

            const Divider(height: 28),

            _InsightTile(
              icon: Icons.calendar_today,
              iconColor: Colors.orange,
              title: "Next EMI",
              value: "Every month on ${insights.nextDueLoan?.dueDay ?? '-'}",
              subtitle: insights.nextDueLoan?.name ?? "No Active Loan",
            ),

            const Divider(height: 28),

            _InsightTile(
              icon: Icons.analytics_outlined,
              iconColor: Colors.purple,
              title: "Loans",
              value: "${insights.activeLoans} Active",
              subtitle: "${insights.closedLoans} Closed",
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: iconColor.withValues(alpha: .12),
          child: Icon(icon, color: iconColor),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}
