import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/add_loan_provider.dart';
import 'widgets/basic_info_step.dart';
import 'widgets/emi_step.dart';
import 'widgets/loan_details_step.dart';
import 'widgets/review_step.dart';

class AddLoanScreen extends ConsumerWidget {
  const AddLoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Loan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (state.currentStep + 1) / 4,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: IndexedStack(
                index: state.currentStep,
                children: const [
                  BasicInfoStep(),
                  LoanDetailsStep(),
                  EmiStep(),
                  ReviewStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}