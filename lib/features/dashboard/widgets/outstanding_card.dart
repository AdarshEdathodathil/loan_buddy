import 'package:flutter/material.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/shared/widgets/app_card.dart';
import 'package:loan_buddy/shared/widgets/loan_progress_bar.dart';

class OutstandingCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress = borrowed == 0 ? 0.0 : (paid / borrowed).clamp(0.0, 1.0);

    return AppCard(
      color: theme.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                "Outstanding Balance",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(
                    alpha: 0.8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Outstanding Amount
          Text(
            CurrencyFormatter.compact(outstanding),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          /// Animated Progress Bar
          const SizedBox(height: 24),

          LoanProgressBar(progress: progress),

          const SizedBox(height: 20),

          /// Statistics
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  title: "Borrowed",
                  value: CurrencyFormatter.compact(borrowed),
                ),
              ),
              Expanded(
                child: _InfoTile(
                  title: "Paid",
                  value: CurrencyFormatter.compact(paid),
                ),
              ),
              Expanded(
                child: _InfoTile(
                  title: "Remaining",
                  value: CurrencyFormatter.compact(outstanding),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
