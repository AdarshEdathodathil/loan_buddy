import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/shared/widgets/app_card.dart';

class NextEmiCard extends ConsumerWidget {
  const NextEmiCard({
    super.key,
    required this.loans,
    required this.onOpenCalendar,
  });

  final List<Loan> loans;
  final VoidCallback onOpenCalendar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currency = ref.watch(currencyProvider);
    final next = _findNext(loans, DateTime.now());

    return AppCard(
      padding: const EdgeInsets.all(20),
      onTap: onOpenCalendar,
      child: next == null
          ? Row(
              children: [
                _IconBox(icon: Icons.event_available_rounded),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nothing due soon',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Your upcoming EMI schedule will appear here.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBox(icon: Icons.upcoming_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Next EMI', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 2),
                          Text(
                            next.loan.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
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
                      child: Text(
                        CurrencyFormatter.format(next.loan.emiAmount, currency),
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      DateFormat('d MMM').format(next.date),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${next.loan.lender} • ${_relativeLabel(next.date)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
    );
  }

  _NextEmi? _findNext(List<Loan> loans, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final candidates = <_NextEmi>[];
    for (final loan in loans.where((loan) => !loan.isClosed)) {
      for (var offset = 0; offset < 2; offset++) {
        final month = DateTime(now.year, now.month + offset);
        final lastDay = DateTime(month.year, month.month + 1, 0).day;
        final date = DateTime(
          month.year,
          month.month,
          loan.dueDay.clamp(1, lastDay),
        );
        if (!date.isBefore(today)) {
          candidates.add(_NextEmi(loan, date));
          break;
        }
      }
    }
    candidates.sort((a, b) => a.date.compareTo(b.date));
    return candidates.isEmpty ? null : candidates.first;
  }

  String _relativeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = date.difference(today).inDays;
    if (days == 0) return 'due today';
    if (days == 1) return 'due tomorrow';
    return 'due in $days days';
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: scheme.onTertiaryContainer),
    );
  }
}

class _NextEmi {
  const _NextEmi(this.loan, this.date);

  final Loan loan;
  final DateTime date;
}
