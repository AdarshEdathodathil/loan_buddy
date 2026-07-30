import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import '../state/add_loan_provider.dart';

class ReviewStep extends ConsumerWidget {
  final Loan? loan;

  const ReviewStep({super.key, this.loan});

  bool get isEditing => loan != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final notifier = ref.read(addLoanProvider.notifier);

    Widget item(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(value),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Loan', style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 20),

          item("Loan Name", state.loanName),
          item("Lender", state.lender),
          item("Loan Type", state.loanType.name),
          item("Total Amount", "${state.totalAmount}"),
          item("Outstanding", "${state.outstandingAmount}"),
          item("Interest", "${state.interestRate}%"),
          item("Monthly EMI", "${state.emiAmount}"),
          item("Due Day", state.dueDay.toString()),

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
                  onPressed: () async {
                    if (isEditing) {
                      await notifier.updateLoan(loan!);
                    } else {
                      await notifier.saveLoan();
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? "Update Loan" : "Save Loan"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
