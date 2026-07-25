import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/widgets/summary_card.dart';
import 'package:loan_buddy/core/notifications/notification_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loanListProvider);
    final stats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Loan Buddy")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddLoanScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Loan"),
      ),
      body: stats.when(
        data: (dashboard) {
          return loans.when(
            data: (items) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Good Morning 👋",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
  onPressed: () {
    NotificationService.instance.showTestNotification();
  },
  child: const Text("Test Notification"),
),

ElevatedButton(
  onPressed: () async {
    await NotificationService.instance.scheduleTestNotification();
  },
  child: const Text("Schedule Notification"),
),

                  const SizedBox(height: 20),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: [
                      SummaryCard(
                        title: "Outstanding",
                        value:
                            "₹${dashboard.totalOutstanding.toStringAsFixed(0)}",
                        icon: Icons.account_balance_wallet,
                        color: Colors.red,
                      ),
                      SummaryCard(
                        title: "Monthly EMI",
                        value: "₹${dashboard.totalEmi.toStringAsFixed(0)}",
                        icon: Icons.payments,
                        color: Colors.green,
                      ),
                      SummaryCard(
                        title: "Active Loans",
                        value: dashboard.activeLoans.toString(),
                        icon: Icons.credit_card,
                        color: Colors.blue,
                      ),
                      SummaryCard(
                        title: "Total Loans",
                        value: items.length.toString(),
                        icon: Icons.account_balance,
                        color: Colors.deepPurple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "My Loans",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  if (items.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            "No loans added yet",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  else
                    ...items.map(
                      (loan) => Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LoanDetailsScreen(loanId: loan.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loan.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  loan.lender,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Outstanding"),
                                    Text(
                                      "₹${loan.outstandingAmount.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Monthly EMI"),
                                    Text(
                                      "₹${loan.emiAmount.toStringAsFixed(0)}",
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                LinearProgressIndicator(
                                  value: loan.totalAmount == 0
                                      ? 0
                                      : ((loan.totalAmount -
                                                    loan.outstandingAmount) /
                                                loan.totalAmount)
                                            .clamp(0.0, 1.0),
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
