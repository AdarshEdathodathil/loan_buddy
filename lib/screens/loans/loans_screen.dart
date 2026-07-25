import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loanListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Loans"),
      ),
      body: loans.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No loans added yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final loan = items[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.account_balance),
                  ),
                  title: Text(
                    loan.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(loan.lender),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "EMI",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "₹${loan.emiAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoanDetailsScreen(
                          loanId: loan.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}