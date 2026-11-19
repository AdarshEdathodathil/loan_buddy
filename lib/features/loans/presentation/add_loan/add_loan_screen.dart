import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/basic_info_step.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/emi_step.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/loan_details_step.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/widgets/review_step.dart';

class AddLoanScreen extends StatelessWidget {
  const AddLoanScreen({super.key, this.loan});

  final Loan? loan;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [initialLoanProvider.overrideWithValue(loan)],
      child: _LoanFormScreen(loan: loan),
    );
  }
}

class _LoanFormScreen extends ConsumerWidget {
  const _LoanFormScreen({required this.loan});

  final Loan? loan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addLoanProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loan == null ? 'Add a loan' : 'Edit loan')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Material(
                color: theme.colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    _StepHeader(currentStep: state.currentStep),
                    Expanded(
                      child: IndexedStack(
                        index: state.currentStep,
                        children: [
                          const BasicInfoStep(),
                          const LoanDetailsStep(),
                          const EmiStep(),
                          ReviewStep(loan: loan),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.currentStep});

  final int currentStep;

  static const _labels = ['Basics', 'Balance', 'Schedule', 'Review'];
  static const _icons = [
    Icons.badge_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.event_repeat_rounded,
    Icons.fact_check_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${currentStep + 1} of 4',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_labels.length, (index) {
              final completed = index < currentStep;
              final active = index == currentStep;
              final color = active || completed
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.outlineVariant;
              return Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: active || completed
                            ? theme.colorScheme.secondaryContainer
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: color),
                      ),
                      child: Icon(
                        completed ? Icons.check_rounded : _icons[index],
                        size: 17,
                        color: active || completed
                            ? theme.colorScheme.onSecondaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!compact || active) ...[
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          _labels[index],
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: active
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: active ? FontWeight.w700 : null,
                          ),
                        ),
                      ),
                    ],
                    if (index < _labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          color: completed
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
