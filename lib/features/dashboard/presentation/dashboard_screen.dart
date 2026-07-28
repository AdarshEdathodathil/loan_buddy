import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/dashboard/widgets/dashboard_header.dart';
import 'package:loan_buddy/features/dashboard/widgets/empty_dashboard.dart';
import 'package:loan_buddy/features/dashboard/widgets/loan_card.dart';
import 'package:loan_buddy/features/dashboard/widgets/quick_actions.dart';
import 'package:loan_buddy/features/dashboard/widgets/quick_stats_grid.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/dashboard/widgets/outstanding_card.dart';
import 'package:loan_buddy/shared/widgets/section_title.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loanListProvider);
    final stats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Buddy"),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
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
                  const DashboardHeader(),

                  const SizedBox(height: 20),

                  OutstandingCard(
                    borrowed: dashboard.totalBorrowed,
                    outstanding: dashboard.totalOutstanding,
                    paid: dashboard.totalBorrowed - dashboard.totalOutstanding,
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 20),

                  QuickStatsGrid(
                    activeLoans: dashboard.activeLoans,
                    closedLoans: dashboard.closedLoans,
                    totalLoans: dashboard.totalLoans,
                    monthlyEmi: dashboard.totalEmi,
                  ),

                  const SizedBox(height: 24),

                  QuickActions(
                    onAddLoan: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddLoanScreen(),
                        ),
                      );
                    },
                    onCalendar: () {},
                    onAnalytics: () {},
                    onSettings: () {},
                  ),

                  const SizedBox(height: 30),

                  const SizedBox(height: 30),

                  SectionTitle(
                    title: "My Loans",
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text("See All"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (items.isEmpty)
                    EmptyDashboard(
                      onAddLoan: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddLoanScreen(),
                          ),
                        );
                      },
                    )
                  else
                    ...items.map(
                      (loan) => LoanCard(
                        loan: loan,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LoanDetailsScreen(loanId: loan.id),
                            ),
                          );
                        },
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
