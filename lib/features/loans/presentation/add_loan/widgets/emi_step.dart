import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';

import '../state/add_loan_provider.dart';

class EmiStep extends ConsumerWidget {
  const EmiStep({super.key});

  Future<void> _pickDate(
    BuildContext context,
    DateTime? currentDate,
    Function(DateTime) onSelected,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

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
          Text('EMI Details', style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 24),

          TextFormField(
            initialValue: state.emiAmount == 0
                ? ''
                : state.emiAmount.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Monthly EMI',
              prefixText: '${currency.symbol} ',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              notifier.updateEmi(double.tryParse(value) ?? 0);
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            initialValue: state.dueDay.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Due Day (1-31)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              notifier.updateDueDay(int.tryParse(value) ?? 1);
            },
          ),

          const SizedBox(height: 20),

          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey),
            ),
            title: const Text("Start Date"),
            subtitle: Text(
              state.startDate == null
                  ? "Select Start Date"
                  : "${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}",
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () {
              _pickDate(context, state.startDate, notifier.updateStartDate);
            },
          ),

          const SizedBox(height: 20),

          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey),
            ),
            title: const Text("End Date"),
            subtitle: Text(
              state.endDate == null
                  ? "Select End Date"
                  : "${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}",
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () {
              _pickDate(context, state.endDate, notifier.updateEndDate);
            },
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.previousStep,
                  child: const Text("Back"),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: FilledButton(
                  onPressed: notifier.nextStep,
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
