import 'package:flutter/material.dart';

class EmptyDashboard extends StatelessWidget {
  final VoidCallback onAddLoan;

  const EmptyDashboard({
    super.key,
    required this.onAddLoan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              "No loans yet",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Add your first loan to start tracking repayments.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddLoan,
              icon: const Icon(Icons.add),
              label: const Text("Add Loan"),
            ),
          ],
        ),
      ),
    );
  }
}