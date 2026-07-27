import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';

import 'state/add_loan_provider.dart';
import 'widgets/basic_info_step.dart';
import 'widgets/emi_step.dart';
import 'widgets/loan_details_step.dart';
import 'widgets/review_step.dart';

class AddLoanScreen extends ConsumerStatefulWidget {
  final Loan? loan;

  const AddLoanScreen({super.key, this.loan});

  @override
  ConsumerState<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends ConsumerState<AddLoanScreen> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    if (widget.loan != null) {
      ref.read(addLoanProvider.notifier).loadLoan(widget.loan!);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addLoanProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loan == null ? "Add Loan" : "Edit Loan"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (state.currentStep + 1) / 4),
            const SizedBox(height: 20),
            Expanded(
              child: IndexedStack(
                index: state.currentStep,
                children: [
                  const BasicInfoStep(),
                  const LoanDetailsStep(),
                  const EmiStep(),
                  ReviewStep(loan: widget.loan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
