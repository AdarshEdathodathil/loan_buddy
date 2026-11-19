import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/loan_form_step.dart';

class EmiStep extends ConsumerWidget {
  const EmiStep({super.key});

  Future<void> _pickDate(
    BuildContext context,
    DateTime? currentDate,
    ValueChanged<DateTime> onSelected,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2150),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);
    final currency = ref.watch(currencyProvider);

    return LoanFormStep(
      title: 'Set the repayment schedule',
      subtitle:
          'These details power your calendar, reminders, and payoff projections.',
      footer: LoanFormActions(
        onBack: notifier.previousStep,
        onContinue: () {
          final error = notifier.validateEmiDetails();
          if (error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
            return;
          }
          notifier.nextStep();
        },
      ),
      children: [
        TextFormField(
          initialValue: state.emiAmount == 0 ? '' : state.emiAmount.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Monthly EMI',
            prefixText: '${currency.symbol} ',
            prefixIcon: const Icon(Icons.calendar_view_month_rounded),
          ),
          onChanged: (value) {
            notifier.updateEmi(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.dueDay.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: const InputDecoration(
            labelText: 'Monthly due day',
            hintText: '1–31',
            prefixIcon: Icon(Icons.event_repeat_rounded),
            helperText: 'Month-end dates adjust automatically',
          ),
          onChanged: (value) {
            notifier.updateDueDay(int.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 520;
            final start = _DateField(
              label: 'Start date',
              date: state.startDate,
              onTap: () =>
                  _pickDate(context, state.startDate, notifier.updateStartDate),
            );
            final end = _DateField(
              label: 'Expected end date',
              date: state.endDate,
              onTap: () =>
                  _pickDate(context, state.endDate, notifier.updateEndDate),
            );
            if (!wide) {
              return Column(children: [start, const SizedBox(height: 12), end]);
            }
            return Row(
              children: [
                Expanded(child: start),
                const SizedBox(width: 12),
                Expanded(child: end),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        TextFormField(
          initialValue: state.notes,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Account reference, special terms…',
            prefixIcon: Icon(Icons.notes_rounded),
            alignLabelWithHint: true,
          ),
          onChanged: notifier.updateNotes,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.notifications_active_outlined),
          title: const Text('EMI reminders'),
          subtitle: const Text(
            'Remind me one day before the due date at 9:00 AM',
          ),
          value: state.reminderEnabled,
          onChanged: (enabled) async {
            if (!enabled) {
              notifier.updateReminderEnabled(false);
              return;
            }

            final granted = await NotificationService.instance
                .requestPermissions();
            if (!context.mounted) return;
            if (!granted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Notification permission is required for EMI reminders.',
                  ),
                ),
              );
              return;
            }
            notifier.updateReminderEnabled(true);
          },
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      date == null
                          ? 'Select date'
                          : DateFormat('d MMM yyyy').format(date!),
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
