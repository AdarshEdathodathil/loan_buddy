import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';

class DashboardStats {
  final double totalBorrowed;
  final double totalOutstanding;
  final double totalPaid;
  final double totalEmi;
  final int activeLoans;
  final int closedLoans;
  final int totalLoans;

  const DashboardStats({
    required this.totalBorrowed,
    required this.totalOutstanding,
    required this.totalPaid,
    required this.totalEmi,
    required this.activeLoans,
    required this.closedLoans,
    required this.totalLoans,
  });
}

final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final loans = ref.watch(loanListProvider);

  return loans.whenData((items) {
    double borrowed = 0;
    double outstanding = 0;
    double emi = 0;

    int active = 0;
    int closed = 0;

    for (final loan in items) {
      borrowed += loan.totalAmount;

      if (!loan.isClosed) {
        outstanding += loan.outstandingAmount;
        emi += loan.emiAmount;
        active++;
      } else {
        closed++;
      }
    }

    return DashboardStats(
      totalBorrowed: borrowed,
      totalOutstanding: outstanding,
      totalPaid: borrowed - outstanding,
      totalEmi: emi,
      activeLoans: active,
      closedLoans: closed,
      totalLoans: items.length,
    );
  });
});