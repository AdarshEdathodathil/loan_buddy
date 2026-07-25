import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_details_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/payments/presentation/add_payment_dialog.dart';
import 'package:loan_buddy/features/payments/providers/payment_controller.dart';
import 'package:loan_buddy/features/payments/providers/payment_history_provider.dart';

class LoanDetailsScreen extends ConsumerWidget {
  final int loanId;

  const LoanDetailsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanDetailsProvider(loanId));
    final payments = ref.watch(paymentHistoryProvider(loanId));

    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: loan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (loan) {
          if (loan == null) {
            return const Center(child: Text('Loan not found'));
          }

          return ListView(
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
                subtitle: Text("${loan.dueDay}"),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
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
                          subtitle: Text(payment.paymentType),
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
          );
        },
      ),
    );
  }
}
