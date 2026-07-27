import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_details_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/payments/presentation/add_payment_dialog.dart';
import 'package:loan_buddy/features/payments/providers/payment_controller.dart';
import 'package:loan_buddy/features/payments/providers/payment_history_provider.dart';
import 'package:loan_buddy/core/services/notification_service.dart';

class LoanDetailsScreen extends ConsumerWidget {
  final int loanId;

  const LoanDetailsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanDetailsProvider(loanId));
    final payments = ref.watch(paymentHistoryProvider(loanId));

    final repository = ref.read(loanRepositoryProvider);

    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return loanAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text("Loan Details")),
        body: Center(child: Text(e.toString())),
      ),

      data: (loan) {
        if (loan == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Loan Details")),
            body: const Center(child: Text("Loan not found")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Loan Details"),
            actions: [
              IconButton(
                tooltip: "Edit Loan",
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddLoanScreen(loan: loan),
                    ),
                  );

                  ref.invalidate(loanDetailsProvider(loan.id));
                  ref.invalidate(loanListProvider);
                  ref.invalidate(dashboardStatsProvider);
                },
              ),

              IconButton(
                tooltip: "Delete Loan",
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Loan"),
                      content: const Text(
                        "This action will permanently delete the loan and all its payment history.\n\nDo you want to continue?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  await NotificationService.instance.cancelReminder(loan.id);

                  await repository.deleteLoanWithPayments(loan.id);

                  ref.invalidate(loanListProvider);
                  ref.invalidate(dashboardStatsProvider);
                  ref.invalidate(paymentHistoryProvider(loan.id));

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(loan.name, style: Theme.of(context).textTheme.headlineSmall),

              const SizedBox(height: 16),

              ListTile(
                title: const Text("Lender"),
                subtitle: Text(loan.lender),
              ),

              ListTile(
                title: const Text("Outstanding"),
                subtitle: Text(currency.format(loan.outstandingAmount)),
              ),

              ListTile(
                title: const Text("Monthly EMI"),
                subtitle: Text(currency.format(loan.emiAmount)),
              ),

              ListTile(
                title: const Text("Interest"),
                subtitle: Text("${loan.interestRate}%"),
              ),

              ListTile(
                title: const Text("Due Day"),
                subtitle: Text(loan.dueDay.toString()),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  icon: const Icon(Icons.payments),
                  label: const Text("Pay EMI"),
                  onPressed: loan.isClosed
                      ? null
                      : () async {
                          final result = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (_) =>
                                AddPaymentDialog(defaultAmount: loan.emiAmount),
                          );

                          if (result == null) return;

                          await ref
                              .read(paymentControllerProvider)
                              .payEmi(
                                loanId: loan.id,
                                amount: result["amount"],
                                paymentDate: result["date"],
                                paymentType: result["type"],
                                remarks: result["remarks"],
                              );

                          ref.invalidate(loanDetailsProvider(loan.id));
                          ref.invalidate(loanListProvider);
                          ref.invalidate(dashboardStatsProvider);
                          ref.invalidate(paymentHistoryProvider(loan.id));

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Payment recorded successfully"),
                              ),
                            );
                          }
                        },
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Payment History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),
              payments.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),

                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(e.toString()),
                  ),
                ),

                data: (items) {
                  if (items.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: Text("No payments recorded yet")),
                      ),
                    );
                  }

                  return Column(
                    children: items.map((payment) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.payments),
                          ),
                          title: Text(currency.format(payment.amount)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payment.paymentType),
                              if (payment.remarks != null &&
                                  payment.remarks!.isNotEmpty)
                                Text(
                                  payment.remarks!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                          trailing: Text(
                            DateFormat(
                              'dd MMM yyyy',
                            ).format(payment.paymentDate),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
