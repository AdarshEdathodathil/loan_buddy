import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loanListProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('EMI calendar')),
      body: SafeArea(
        top: false,
        child: loans.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppEmptyState(
            icon: Icons.event_busy_rounded,
            title: 'Could not load your calendar',
            message: error.toString(),
          ),
          data: (items) {
            final payments = _paymentsForMonth(items);
            final total = payments.fold<double>(
              0,
              (sum, payment) => sum + payment.loan.emiAmount,
            );
            return AppPage(
              child: ListView(
                children: [
                  _MonthSelector(
                    month: _selectedMonth,
                    onPrevious: () => _changeMonth(-1),
                    onNext: () => _changeMonth(1),
                    onToday: _goToToday,
                  ),
                  const SizedBox(height: 18),
                  _CalendarMonthGrid(
                    month: _selectedMonth,
                    payments: payments,
                    selectedDay: _selectedDay,
                    onDaySelected: (day) {
                      setState(() => _selectedDay = day);
                    },
                  ),
                  const SizedBox(height: 16),
                  _MonthSummary(
                    paymentCount: payments.length,
                    currencyText: CurrencyFormatter.format(total, currency),
                  ),
                  const SizedBox(height: 28),
                  AppSectionHeader(
                    title: 'Payment schedule',
                    subtitle: payments.isEmpty
                        ? 'No payments scheduled this month.'
                        : '${payments.length} payment${payments.length == 1 ? '' : 's'} due',
                  ),
                  const SizedBox(height: 14),
                  if (payments.isEmpty)
                    const AppEmptyState(
                      icon: Icons.event_available_rounded,
                      title: 'A clear month',
                      message:
                          'There are no active loan payments due this month.',
                    )
                  else
                    ...payments.map(
                      (payment) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PaymentTile(
                          payment: payment,
                          amount: CurrencyFormatter.format(
                            payment.loan.emiAmount,
                            currency,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LoanDetailsScreen(loanId: payment.loan.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
      _selectedDay = null;
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedMonth = DateTime(now.year, now.month);
      _selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  List<_ScheduledPayment> _paymentsForMonth(List<Loan> loans) {
    final selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month);
    final lastDay = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;
    final result =
        loans
            .where((loan) {
              final startMonth = DateTime(
                loan.startDate.year,
                loan.startDate.month,
              );
              final endMonth = DateTime(loan.endDate.year, loan.endDate.month);
              return !loan.isClosed &&
                  !selectedMonth.isBefore(startMonth) &&
                  !selectedMonth.isAfter(endMonth);
            })
            .map(
              (loan) => _ScheduledPayment(
                loan,
                DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month,
                  loan.dueDay.clamp(1, lastDay),
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return result;
  }
}

class _CalendarMonthGrid extends StatelessWidget {
  const _CalendarMonthGrid({
    required this.month,
    required this.payments,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final DateTime month;
  final List<_ScheduledPayment> payments;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  static const _weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(month.year, month.month);
    final leadingEmptyDays = firstDay.weekday - DateTime.monday;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final usedCells = leadingEmptyDays + daysInMonth;
    final cellCount = ((usedCells / 7).ceil() * 7).clamp(35, 42);
    final dueCounts = <int, int>{};
    for (final payment in payments) {
      dueCounts.update(
        payment.date.day,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        child: Column(
          children: [
            Row(
              children: _weekdayLabels
                  .map(
                    (label) => Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cellCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: .92,
              ),
              itemBuilder: (context, index) {
                final dayNumber = index - leadingEmptyDays + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final date = DateTime(month.year, month.month, dayNumber);
                return _CalendarDay(
                  date: date,
                  dueCount: dueCounts[dayNumber] ?? 0,
                  selected: _sameDate(date, selectedDay),
                  onTap: () => onDaySelected(date),
                );
              },
            ),
            if (payments.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'EMI due date',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _sameDate(DateTime left, DateTime? right) {
    return right != null &&
        left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.dueCount,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final int dueCount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final foreground = selected
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label:
          '${DateFormat('EEEE, d MMMM yyyy').format(date)}${dueCount == 0 ? '' : ', $dueCount EMI ${dueCount == 1 ? 'payment' : 'payments'} due'}',
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: selected
              ? theme.colorScheme.secondaryContainer
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: isToday && !selected
                ? BorderSide(color: theme.colorScheme.secondary)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: isToday || selected ? FontWeight.w700 : null,
                  ),
                ),
                const SizedBox(height: 4),
                if (dueCount > 0)
                  Container(
                    width: dueCount > 1 ? 16 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.onSecondaryContainer
                          : theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: dueCount > 1
                        ? Text(
                            '$dueCount',
                            style: const TextStyle(
                              fontSize: 6,
                              height: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  )
                else
                  const SizedBox(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Previous month',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: onToday,
                child: const Text('Jump to today'),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Next month',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.paymentCount, required this.currencyText});

  final int paymentCount;
  final String currencyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: .65),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total EMI this month',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 3),
                Text(currencyText, style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
          Text(
            '$paymentCount due',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.amount,
    required this.onTap,
  });

  final _ScheduledPayment payment;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final overdue = payment.date.isBefore(todayOnly);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: overdue
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              DateFormat('dd').format(payment.date),
              style: theme.textTheme.titleMedium?.copyWith(
                color: overdue
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ),
        title: Text(payment.loan.name),
        subtitle: Text(
          '${payment.loan.lender} • ${DateFormat('EEE, d MMM').format(payment.date)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: theme.textTheme.titleSmall),
            const SizedBox(height: 2),
            Text(
              overdue ? 'Overdue' : 'Upcoming',
              style: theme.textTheme.labelSmall?.copyWith(
                color: overdue
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduledPayment {
  const _ScheduledPayment(this.loan, this.date);

  final Loan loan;
  final DateTime date;
}
