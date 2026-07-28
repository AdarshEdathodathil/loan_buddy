import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_details_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/payments/presentation/add_payment_dialog.dart';
import 'package:loan_buddy/features/payments/providers/payment_controller.dart';
import 'package:loan_buddy/features/payments/providers/payment_history_provider.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/widgets/loan_header.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/widgets/loan_summary_card.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/widgets/repayment_progress_card.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/widgets/payment_history_card.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/widgets/emi_timeline_card.dart';

class LoanDetailsScreen extends ConsumerWidget {
  final int loanId;

  const LoanDetailsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanDetailsProvider(loanId));
    final payments = ref.watch(paymentHistoryProvider(loanId));

    final repository = ref.read(loanRepositoryProvider);


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
              LoanHeader(loan: loan),

              const SizedBox(height: 20),

              LoanSummaryCard(loan: loan),

              const SizedBox(height: 20),

              RepaymentProgressCard(
                borrowed: loan.totalAmount,
                outstanding: loan.outstandingAmount,
              ),

              const SizedBox(height: 20),

              // Existing Pay EMI button
              const SizedBox(height: 20),

              // PaymentHistoryCard(payments: payments),
              const SizedBox(height: 16),

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

              payments.when(
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(e.toString()),
                  ),
                ),

                data: (items) => PaymentHistoryCard(payments: items),
              ),
              const SizedBox(height: 20),

              EmiTimelineCard(loan: loan),
            ],
          ),
        );
      },
    );
  }
}
