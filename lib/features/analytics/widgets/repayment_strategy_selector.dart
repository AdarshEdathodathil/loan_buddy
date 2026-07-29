import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/models/repayment_strategy_type.dart';
import 'package:loan_buddy/features/analytics/providers/repayment_strategy_provider.dart';

class RepaymentStrategySelector extends ConsumerWidget {
  const RepaymentStrategySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(repaymentStrategyProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repayment Strategy',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            ...RepaymentStrategyType.values.map(
              (strategy) => RadioListTile<RepaymentStrategyType>(
                value: strategy,
                // ignore: deprecated_member_use
                groupValue: selected,
                title: Text(_title(strategy)),
                subtitle: Text(_description(strategy)),
                // ignore: deprecated_member_use
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(repaymentStrategyProvider.notifier)
                        .state = value;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(RepaymentStrategyType strategy) {
    switch (strategy) {
      case RepaymentStrategyType.smart:
        return '🧠 Smart';
      case RepaymentStrategyType.snowball:
        return '❄️ Snowball';
      case RepaymentStrategyType.avalanche:
        return '🏔️ Avalanche';
      case RepaymentStrategyType.lowestEmi:
        return '💸 Lowest EMI';
      case RepaymentStrategyType.earliestFinish:
        return '📅 Earliest Finish';
    }
  }

  String _description(RepaymentStrategyType strategy) {
    switch (strategy) {
      case RepaymentStrategyType.smart:
        return 'Balanced recommendation using multiple factors.';
      case RepaymentStrategyType.snowball:
        return 'Pay the smallest balance first.';
      case RepaymentStrategyType.avalanche:
        return 'Pay the highest interest loan first.';
      case RepaymentStrategyType.lowestEmi:
        return 'Reduce monthly EMI commitments.';
      case RepaymentStrategyType.earliestFinish:
        return 'Close the loan finishing soonest.';
    }
  }
}