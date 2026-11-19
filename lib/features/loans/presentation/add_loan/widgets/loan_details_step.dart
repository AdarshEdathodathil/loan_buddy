import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/loan_form_step.dart';

class LoanDetailsStep extends ConsumerWidget {
  const LoanDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);
    final currency = ref.watch(currencyProvider);

    return LoanFormStep(
      title: 'Add the current balances',
      subtitle:
          'Enter the original amount and what remains today. This keeps your progress accurate.',
      footer: LoanFormActions(
        onBack: notifier.previousStep,
        onContinue: () {
          final error = notifier.validateLoanDetails();
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
          initialValue: state.totalAmount == 0
              ? ''
              : state.totalAmount.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_DecimalInputFormatter()],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Original loan amount',
            prefixText: '${currency.symbol} ',
            prefixIcon: const Icon(Icons.payments_outlined),
            helperText: 'The amount originally borrowed',
          ),
          onChanged: (value) {
            notifier.updateTotalAmount(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.outstandingAmount == 0
              ? ''
              : state.outstandingAmount.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_DecimalInputFormatter()],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Outstanding balance',
            prefixText: '${currency.symbol} ',
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            helperText: 'What you still owe today',
          ),
          onChanged: (value) {
            notifier.updateOutstanding(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.interestRate == 0
              ? ''
              : state.interestRate.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_DecimalInputFormatter()],
          decoration: const InputDecoration(
            labelText: 'Annual interest rate',
            suffixText: '% p.a.',
            prefixIcon: Icon(Icons.percent_rounded),
            helperText: 'Use the rate from your latest loan statement',
          ),
          onChanged: (value) {
            notifier.updateInterest(double.tryParse(value) ?? 0);
          },
        ),
      ],
    );
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty ||
        RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
