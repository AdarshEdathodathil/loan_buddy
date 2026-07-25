import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/add_loan_provider.dart';
import '../../../data/models/loan_type.dart';

class BasicInfoStep extends ConsumerWidget {
  const BasicInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 24),

          TextFormField(
            initialValue: state.loanName,
            decoration: const InputDecoration(
              labelText: 'Loan Name',
              border: OutlineInputBorder(),
            ),
            onChanged: notifier.updateLoanName,
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<LoanType>(
            initialValue: state.loanType,
            decoration: const InputDecoration(
              labelText: 'Loan Type',
              border: OutlineInputBorder(),
            ),
            items: LoanType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                notifier.updateLoanType(value);
              }
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            initialValue: state.lender,
            decoration: const InputDecoration(
              labelText: 'Lender',
              border: OutlineInputBorder(),
            ),
            onChanged: notifier.updateLender,
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: notifier.nextStep,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}