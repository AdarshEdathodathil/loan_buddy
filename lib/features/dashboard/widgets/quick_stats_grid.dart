import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class QuickStatsGrid extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.08,
      children: [
        _StatTile(
          icon: Icons.credit_score_rounded,
          title: "Active Loans",
          value: activeLoans.toString(),
          color: Colors.blue,
        ),
        _StatTile(
          icon: Icons.task_alt_rounded,
          title: "Closed Loans",
          value: closedLoans.toString(),
          color: Colors.green,
        ),
        _StatTile(
          icon: Icons.payments_rounded,
          title: "Monthly EMI",
          value: CurrencyFormatter.compact(
            monthlyEmi,
            currency,
          ),
          color: Colors.orange,
        ),
        _StatTile(
          icon: Icons.account_balance_rounded,
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

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      elevation: 0,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 26,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}