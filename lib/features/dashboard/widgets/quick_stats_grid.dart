import 'package:flutter/material.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class QuickStatsGrid extends StatelessWidget {
  final int activeLoans;
  final int closedLoans;
  final int totalLoans;
  final double monthlyEmi;

  const QuickStatsGrid({
    super.key,
    required this.activeLoans,
    required this.closedLoans,
    required this.totalLoans,
    required this.monthlyEmi,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.25,
      children: [
        _StatTile(
          icon: Icons.credit_card,
          title: "Active Loans",
          value: activeLoans.toString(),
          color: Colors.blue,
        ),
        _StatTile(
          icon: Icons.check_circle,
          title: "Closed Loans",
          value: closedLoans.toString(),
          color: Colors.green,
        ),
        _StatTile(
          icon: Icons.payments,
          title: "Monthly EMI",
          value: CurrencyFormatter.compact(monthlyEmi),
          color: Colors.orange,
        ),
        _StatTile(
          icon: Icons.account_balance,
          title: "Total Loans",
          value: totalLoans.toString(),
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const Spacer(),

            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}