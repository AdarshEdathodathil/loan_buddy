import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/database_provider.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LoanRepository(db);
});