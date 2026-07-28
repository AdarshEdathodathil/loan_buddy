import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/models/smart_insights.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final smartInsightsProvider = StreamProvider<SmartInsights>((ref) {
  final repository = ref.watch(loanRepositoryProvider);

  return repository.watchLoans().map((loans) {
    final activeLoans =
        loans.where((loan) => !loan.isClosed).toList();

    final closedLoans =
        loans.where((loan) => loan.isClosed).toList();

    if (activeLoans.isEmpty) {
      throw Exception("No active loans");
    }

    activeLoans.sort(
      (a, b) => b.totalAmount.compareTo(a.totalAmount),
    );

    final largestLoan = activeLoans.first;

    activeLoans.sort(
      (a, b) => b.emiAmount.compareTo(a.emiAmount),
    );

    final highestEmiLoan = activeLoans.first;

    activeLoans.sort(
      (a, b) => a.dueDay.compareTo(b.dueDay),
    );

    final nextDueLoan = activeLoans.first;

    return SmartInsights(
      largestLoan: largestLoan,
      highestEmiLoan: highestEmiLoan,
      nextDueLoan: nextDueLoan,
      activeLoans: activeLoans.length,
      closedLoans: closedLoans.length,
    );
  });
});