import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/data/models/loan_type.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/loan_form_step.dart';

class BasicInfoStep extends ConsumerWidget {
  const BasicInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);

    return LoanFormStep(
      title: 'Tell us about this loan',
      subtitle:
          'Use a memorable name so you can identify it quickly on your dashboard.',
      footer: LoanFormActions(
        onContinue: () {
          final error = notifier.validateBasicInfo();
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
          initialValue: state.loanName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Loan name',
            hintText: 'Home loan, Car loan…',
            prefixIcon: Icon(Icons.label_outline_rounded),
          ),
          onChanged: notifier.updateLoanName,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.lender,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Lender',
            hintText: 'Bank or financial institution',
            prefixIcon: Icon(Icons.account_balance_outlined),
          ),
          onChanged: notifier.updateLender,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<LoanType>(
          initialValue: state.loanType,
          decoration: const InputDecoration(
            labelText: 'Loan type',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: LoanType.values
              .map(
                (type) =>
                    DropdownMenuItem(value: type, child: Text(_labelFor(type))),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) notifier.updateLoanType(value);
          },
        ),
        const SizedBox(height: 22),
        _PrivacyNote(),
      ],
    );
  }

  static String _labelFor(LoanType type) {
    final text = type.name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}

class _PrivacyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: scheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your loan information stays on this device.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
