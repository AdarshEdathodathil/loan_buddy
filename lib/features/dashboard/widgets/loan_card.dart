import 'package:flutter/material.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/shared/widgets/app_card.dart';
import 'package:loan_buddy/shared/widgets/loan_progress_bar.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback onTap;

  const LoanCard({
    super.key,
    required this.loan,
    required this.onTap,
  });

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress = loan.totalAmount == 0
        ? 0.0
        : ((loan.totalAmount - loan.outstandingAmount) /
                loan.totalAmount)
            .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.account_balance,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loan.lender,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                _StatusChip(isClosed: loan.isClosed),
              ],
            ),

            const SizedBox(height: 24),

            LoanProgressBar(
              progress: progress,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    title: "Outstanding",
                    value: CurrencyFormatter.compact(
                      loan.outstandingAmount,
                    ),
                  ),
                ),

                Expanded(
                  child: _InfoItem(
                    title: "Monthly EMI",
                    value: CurrencyFormatter.compact(
                      loan.emiAmount,
                    ),
                  ),
                ),

                Expanded(
                  child: _InfoItem(
                    title: "Due Day",
                    value: loan.dueDay.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "View Details",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall,
        ),
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
class _StatusChip extends StatelessWidget {
  final bool isClosed;

  const _StatusChip({
    required this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isClosed
        ? Colors.green
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isClosed ? "Closed" : "Active",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}