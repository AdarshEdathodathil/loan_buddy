import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/dashboard/providers/dashboard_provider.dart';
import 'package:loan_buddy/features/dashboard/widgets/dashboard_header.dart';
import 'package:loan_buddy/features/dashboard/widgets/empty_dashboard.dart';
import 'package:loan_buddy/features/dashboard/widgets/loan_card.dart';
import 'package:loan_buddy/features/dashboard/widgets/next_emi_card.dart';
import 'package:loan_buddy/features/dashboard/widgets/outstanding_card.dart';
import 'package:loan_buddy/features/dashboard/widgets/quick_stats_grid.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.onShowLoans,
    required this.onShowCalendar,
    required this.onShowAnalytics,
  });

  final VoidCallback onShowLoans;
  final VoidCallback onShowCalendar;
  final VoidCallback onShowAnalytics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loanListProvider);
    final stats = ref.watch(dashboardStatsProvider);
    final compact = MediaQuery.sizeOf(context).width < 520;

    void addLoan() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddLoanScreen()),
      );
    }

    return Scaffold(
      floatingActionButton: compact
          ? FloatingActionButton(
              onPressed: addLoan,
              tooltip: 'Add loan',
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: SafeArea(
        child: stats.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _DashboardError(message: error.toString()),
          data: (dashboard) => loans.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _DashboardError(message: error.toString()),
            data: (items) => AppPage(
              child: ListView(
                children: [
                  DashboardHeader(onAddLoan: addLoan),
                  const SizedBox(height: 26),
                  if (items.isEmpty)
                    EmptyDashboard(onAddLoan: addLoan)
                  else ...[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 760;
                        final balance = OutstandingCard(
                          borrowed: dashboard.totalBorrowed,
                          outstanding: dashboard.totalOutstanding,
                          paid: dashboard.totalPaid,
                        );
                        final supporting = Column(
                          children: [
                            NextEmiCard(
                              loans: items,
                              onOpenCalendar: onShowCalendar,
                            ),
                            const SizedBox(height: 14),
                            QuickStatsGrid(
                              activeLoans: dashboard.activeLoans,
                              closedLoans: dashboard.closedLoans,
                              totalLoans: dashboard.totalLoans,
                              monthlyEmi: dashboard.totalEmi,
                              onLoansTap: onShowLoans,
                              onAnalyticsTap: onShowAnalytics,
                            ),
                          ],
                        );

                        if (!wide) {
                          return Column(
                            children: [
                              balance,
                              const SizedBox(height: 16),
                              supporting,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: balance),
                            const SizedBox(width: 18),
                            Expanded(flex: 5, child: supporting),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 34),
                    AppSectionHeader(
                      title: 'Your loans',
                      subtitle:
                          'Keep an eye on balances and repayment progress.',
                      action: TextButton(
                        onPressed: onShowLoans,
                        child: const Text('View all'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...items
                        .take(3)
                        .map(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'Could not load your dashboard',
      message: message,
    );
  }
}
