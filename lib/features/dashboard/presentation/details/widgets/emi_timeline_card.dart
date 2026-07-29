import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/database/app_database.dart';

class EmiTimelineCard extends StatefulWidget {
  final Loan loan;
  final List<Payment> payments;

  const EmiTimelineCard({
    super.key,
    required this.loan,
    required this.payments,
  });

  @override
  State<EmiTimelineCard> createState() => _EmiTimelineCardState();
}

class _EmiTimelineCardState extends State<EmiTimelineCard>
    with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final months = _generateMonths();
    final isLoanClosed = widget.loan.isClosed;

    final paidMonths = widget.payments
        .map((p) => '${p.emiForMonth.year}-${p.emiForMonth.month}')
        .toSet();

    final timelineMonths = isLoanClosed
        ? months
              .where((m) => paidMonths.contains('${m.year}-${m.month}'))
              .toList()
        : months;

    final DateTime? nextEmi = isLoanClosed
        ? null
        : months.firstWhere(
            (m) => !paidMonths.contains('${m.year}-${m.month}'),
            orElse: () => months.last,
          );

    final remainingEmis = isLoanClosed
        ? 0
        : months
              .where((m) => !paidMonths.contains('${m.year}-${m.month}'))
              .length;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() => _expanded = !_expanded);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.timeline),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "EMI Timeline",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    AnimatedRotation(
                      turns: _expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _SummaryTile(
                    title: "Next EMI",
                    value: isLoanClosed
                        ? "Completed"
                        : DateFormat("dd MMM yyyy").format(nextEmi!),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _SummaryTile(
                    title: "Remaining",
                    value: isLoanClosed ? "Completed" : "$remainingEmis EMIs",
                  ),
                ),
              ],
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: !_expanded
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          ...timelineMonths.map((date) {
                            final paid = paidMonths.contains(
                              '${date.year}-${date.month}',
                            );

                            final isNext =
                                !isLoanClosed &&
                                nextEmi != null &&
                                nextEmi.year == date.year &&
                                nextEmi.month == date.month;

                            IconData icon;
                            Color color;
                            String status;

                            if (paid) {
                              icon = Icons.check_circle;
                              color = Colors.green;
                              status = "Paid";
                            } else if (isNext) {
                              icon = Icons.schedule;
                              color = Colors.orange;
                              status = "Next";
                            } else {
                              icon = Icons.radio_button_unchecked;
                              color = Colors.grey;
                              status = "Upcoming";
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(icon, color: color),
                              title: Text(DateFormat('MMM yyyy').format(date)),
                              trailing: Text(status),
                            );
                          }),

                          if (isLoanClosed) ...[
                            const SizedBox(height: 24),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: .25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.emoji_events_rounded,
                                    color: Colors.green,
                                    size: 48,
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    "Loan Completed 🎉",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Congratulations! You have successfully repaid this loan.",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _generateMonths() {
    final months = <DateTime>[];

    DateTime current = DateTime(
      widget.loan.startDate.year,
      widget.loan.startDate.month,
    );

    while (!current.isAfter(widget.loan.endDate)) {
      months.add(current);

      current = DateTime(current.year, current.month + 1);
    }

    return months;
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
