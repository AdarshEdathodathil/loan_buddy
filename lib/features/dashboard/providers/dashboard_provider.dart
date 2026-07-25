import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';

class DashboardStats {
  final double totalOutstanding;
  final double totalEmi;
  final int activeLoans;

  const DashboardStats({
    required this.totalOutstanding,
    required this.totalEmi,
    required this.activeLoans,
  });
}

final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final loans = ref.watch(loanListProvider);

  return loans.whenData((items) {
    double outstanding = 0;
    double emi = 0;
    int active = 0;

    for (final loan in items) {
      if (!loan.isClosed) {
        outstanding += loan.outstandingAmount;
        emi += loan.emiAmount;
        active++;
      }
    }

    return DashboardStats(
      totalOutstanding: outstanding,
      totalEmi: emi,
      activeLoans: active,
    );
  });
});