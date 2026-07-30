import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';

import '../state/add_loan_provider.dart';

class LoanDetailsStep extends ConsumerWidget {
  const LoanDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);
    final currency = ref.watch(currencyProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 24),

          TextFormField(
            initialValue: state.totalAmount == 0
                ? ''
                : state.totalAmount.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Total Loan Amount',
              prefixText: '${currency.symbol} ',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              notifier.updateTotalAmount(double.tryParse(value) ?? 0);
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            initialValue: state.outstandingAmount == 0
                ? ''
                : state.outstandingAmount.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Outstanding Amount',
              prefixText: '${currency.symbol} ',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              notifier.updateOutstanding(double.tryParse(value) ?? 0);
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            initialValue: state.interestRate == 0
                ? ''
                : state.interestRate.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Interest Rate',
              suffixText: '%',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              notifier.updateInterest(double.tryParse(value) ?? 0);
            },
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.previousStep,
                  child: const Text('Back'),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: FilledButton(
                  onPressed: notifier.nextStep,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
