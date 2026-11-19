import 'package:flutter/material.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class EmptyDashboard extends StatelessWidget {
  final VoidCallback onAddLoan;

  const EmptyDashboard({super.key, required this.onAddLoan});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Your debt plan starts here',
      message:
          'Add your first loan to track payments, see your progress, and build a payoff plan.',
      action: FilledButton.icon(
        onPressed: onAddLoan,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add your first loan'),
      ),
    );
  }
}
