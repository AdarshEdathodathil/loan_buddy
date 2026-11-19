import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/loan_form_step.dart';

class ReviewStep extends ConsumerStatefulWidget {
  const ReviewStep({super.key, this.loan});

  final Loan? loan;

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);
    final currency = ref.watch(currencyProvider);

    return LoanFormStep(
      title: 'Review your loan',
      subtitle:
          'Check the details before saving. You can edit everything later.',
      footer: LoanFormActions(
        onBack: notifier.previousStep,
        loading: _saving,
        continueLabel: widget.loan == null ? 'Save loan' : 'Update loan',
        onContinue: _save,
      ),
      children: [
        _ReviewSection(
          title: 'Loan',
          icon: Icons.account_balance_rounded,
          items: [
            ('Name', state.loanName),
            ('Lender', state.lender),
            ('Type', _friendlyName(state.loanType.name)),
          ],
        ),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'Balance',
          icon: Icons.payments_rounded,
          items: [
            ('Original', CurrencyFormatter.format(state.totalAmount, currency)),
            (
              'Outstanding',
              CurrencyFormatter.format(state.outstandingAmount, currency),
            ),
            ('Interest', '${state.interestRate.toStringAsFixed(2)}% p.a.'),
          ],
        ),
        const SizedBox(height: 14),
        _ReviewSection(
          title: 'Schedule',
          icon: Icons.calendar_month_rounded,
          items: [
            (
              'Monthly EMI',
              CurrencyFormatter.format(state.emiAmount, currency),
            ),
            ('Due date', 'Day ${state.dueDay} of every month'),
            (
              'Term',
              '${DateFormat('MMM yyyy').format(state.startDate!)} – '
                  '${DateFormat('MMM yyyy').format(state.endDate!)}',
            ),
          ],
        ),
        if (state.notes.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          _ReviewSection(
            title: 'Notes',
            icon: Icons.notes_rounded,
            items: [('Details', state.notes.trim())],
          ),
        ],
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final notifier = ref.read(addLoanProvider.notifier);
    try {
      if (widget.loan == null) {
        await notifier.saveLoan();
      } else {
        await notifier.updateLoan(widget.loan!);
      }
      if (mounted) Navigator.pop(context);
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _friendlyName(String value) {
    final spaced = value.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.secondary),
              const SizedBox(width: 9),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      item.$1,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.$2,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
