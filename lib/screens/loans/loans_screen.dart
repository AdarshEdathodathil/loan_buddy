import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/dashboard/presentation/details/loan_details_screen.dart';
import 'package:loan_buddy/features/dashboard/widgets/loan_card.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

enum _LoanFilter { all, active, closed }

class LoansScreen extends ConsumerStatefulWidget {
  const LoansScreen({super.key});

  @override
  ConsumerState<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends ConsumerState<LoansScreen> {
  final _searchController = TextEditingController();
  _LoanFilter _filter = _LoanFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loanListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.tonalIcon(
              onPressed: _addLoan,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: loans.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load loans',
            message: error.toString(),
          ),
          data: (items) {
            final visible = _filterLoans(items);
            return AppPage(
              child: ListView(
                children: [
                  Text(
                    'Manage every balance in one place.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search by loan or lender',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          count: items.length,
                          selected: _filter == _LoanFilter.all,
                          onSelected: () =>
                              setState(() => _filter = _LoanFilter.all),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Active',
                          count: items.where((loan) => !loan.isClosed).length,
                          selected: _filter == _LoanFilter.active,
                          onSelected: () =>
                              setState(() => _filter = _LoanFilter.active),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Closed',
                          count: items.where((loan) => loan.isClosed).length,
                          selected: _filter == _LoanFilter.closed,
                          onSelected: () =>
                              setState(() => _filter = _LoanFilter.closed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (visible.isEmpty)
                    AppEmptyState(
                      icon: items.isEmpty
                          ? Icons.account_balance_wallet_outlined
                          : Icons.search_off_rounded,
                      title: items.isEmpty
                          ? 'No loans yet'
                          : 'No matching loans',
                      message: items.isEmpty
                          ? 'Add a loan to begin tracking your repayment progress.'
                          : 'Try a different search or filter.',
                      action: items.isEmpty
                          ? FilledButton.icon(
                              onPressed: _addLoan,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add loan'),
                            )
                          : null,
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 760 ? 2 : 1;
                        if (columns == 1) {
                          return Column(
                            children: visible.map(_loanCard).toList(),
                          );
                        }
                        const gap = 14.0;
                        final width = (constraints.maxWidth - gap) / 2;
                        return Wrap(
                          spacing: gap,
                          children: visible
                              .map(
                                (loan) => SizedBox(
                                  width: width,
                                  child: _loanCard(loan),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Loan> _filterLoans(List<Loan> loans) {
    final query = _searchController.text.trim().toLowerCase();
    return loans.where((loan) {
      final matchesFilter = switch (_filter) {
        _LoanFilter.all => true,
        _LoanFilter.active => !loan.isClosed,
        _LoanFilter.closed => loan.isClosed,
      };
      final matchesQuery =
          query.isEmpty ||
          loan.name.toLowerCase().contains(query) ||
          loan.lender.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  Widget _loanCard(Loan loan) {
    return LoanCard(
      loan: loan,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoanDetailsScreen(loanId: loan.id)),
        );
      },
    );
  }

  void _addLoan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddLoanScreen()),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      label: Text('$label  $count'),
      showCheckmark: false,
    );
  }
}
