import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/theme/app_colors.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/shared/widgets/app_card.dart';
import 'package:loan_buddy/shared/widgets/loan_progress_bar.dart';

class LoanCard extends ConsumerWidget {
  const LoanCard({super.key, required this.loan, required this.onTap});

  final Loan loan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currency = ref.watch(currencyProvider);
    final progress = loan.totalAmount <= 0
        ? 0.0
        : ((loan.totalAmount - loan.outstandingAmount) / loan.totalAmount)
              .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _iconForLoanType(loan.loanType),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        loan.lender,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(isClosed: loan.isClosed),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _Amount(
                    label: 'Outstanding',
                    value: CurrencyFormatter.compact(
                      loan.outstandingAmount,
                      currency,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _Amount(
                  label: 'Monthly EMI',
                  value: CurrencyFormatter.compact(loan.emiAmount, currency),
                  alignEnd: true,
                ),
              ],
            ),
            const SizedBox(height: 15),
            LoanProgressBar(progress: progress, height: 7),
            const SizedBox(height: 2),
            Text(
              loan.isClosed ? 'Loan completed' : 'Due on day ${loan.dueDay}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForLoanType(int type) {
    return switch (type) {
      1 => Icons.home_rounded,
      2 => Icons.directions_car_filled_rounded,
      3 => Icons.school_rounded,
      _ => Icons.account_balance_rounded,
    };
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isClosed});

  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    final color = isClosed
        ? AppColors.success
        : Theme.of(context).colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isClosed ? 'Closed' : 'Active',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
