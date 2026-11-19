import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/core/theme/app_colors.dart';

class QuickStatsGrid extends ConsumerWidget {
  final int activeLoans;
  final int closedLoans;
  final int totalLoans;
  final double monthlyEmi;
  final VoidCallback onLoansTap;
  final VoidCallback onAnalyticsTap;

  const QuickStatsGrid({
    super.key,
    required this.activeLoans,
    required this.closedLoans,
    required this.totalLoans,
    required this.monthlyEmi,
    required this.onLoansTap,
    required this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final tileHeight = 132.0 + ((textScale - 1).clamp(0, 1) * 44);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      mainAxisExtent: tileHeight,
      children: [
        _StatTile(
          icon: Icons.credit_score_rounded,
          title: "Active Loans",
          value: activeLoans.toString(),
          color: Theme.of(context).colorScheme.secondary,
          onTap: onLoansTap,
        ),
        _StatTile(
          icon: Icons.task_alt_rounded,
          title: "Closed Loans",
          value: closedLoans.toString(),
          color: AppColors.success,
          onTap: onLoansTap,
        ),
        _StatTile(
          icon: Icons.payments_rounded,
          title: "Monthly EMI",
          value: CurrencyFormatter.compact(monthlyEmi, currency),
          color: AppColors.warning,
          onTap: onAnalyticsTap,
        ),
        _StatTile(
          icon: Icons.account_balance_rounded,
          title: "Total Loans",
          value: totalLoans.toString(),
          color: Theme.of(context).colorScheme.primary,
          onTap: onLoansTap,
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
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
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
