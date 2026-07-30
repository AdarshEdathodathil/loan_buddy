import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/shared/widgets/app_card.dart';
import 'package:loan_buddy/shared/widgets/loan_progress_bar.dart';

class OutstandingCard extends ConsumerWidget {
  final double borrowed;
  final double outstanding;
  final double paid;

  const OutstandingCard({
    super.key,
    required this.borrowed,
    required this.outstanding,
    required this.paid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currency = ref.watch(currencyProvider);

    final progress =
        borrowed == 0 ? 0.0 : (paid / borrowed).clamp(0.0, 1.0);

    final percentage = (progress * 100).toStringAsFixed(0);

    return AppCard(
      color: theme.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Outstanding Balance",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "$percentage%",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Outstanding Amount
          Text(
            CurrencyFormatter.compact(
              outstanding,
              currency,
            ),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Current outstanding across all active loans",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          LoanProgressBar(
            progress: progress,
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$percentage% Repaid",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Borrowed",
                  value: CurrencyFormatter.compact(
                    borrowed,
                    currency,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _InfoCard(
                  icon: Icons.check_circle_outline,
                  title: "Paid",
                  value: CurrencyFormatter.compact(
                    paid,
                    currency,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _InfoCard(
                  icon: Icons.payments_outlined,
                  title: "Balance",
                  value: CurrencyFormatter.compact(
                    outstanding,
                    currency,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}