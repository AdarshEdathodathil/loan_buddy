import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/currency/supported_currencies.dart';
import 'package:loan_buddy/features/loans/providers/loan_list_provider.dart';
import 'package:loan_buddy/features/settings/widgets/selection_option_card.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyProvider);
    final notifier = ref.read(currencyProvider.notifier);
    final loans = ref.watch(loanListProvider);
    final hasLoans = loans.asData?.value.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Currency')),
      body: SafeArea(
        child: AppPage(
          maxWidth: 720,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your preferred currency',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hasLoans
                          ? 'Currency is locked while loans exist so saved values '
                                'are never silently relabelled.'
                          : 'Choose before adding your first loan. Loan Buddy does '
                                'not perform exchange-rate conversion.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              ...SupportedCurrencies.supported.map(
                (currency) => SelectionOptionCard(
                  leading: currency.symbol,
                  title: currency.name,
                  subtitle: '${currency.code} (${currency.symbol})',
                  selected: currency.code == selectedCurrency.code,
                  onTap: hasLoans && currency.code != selectedCurrency.code
                      ? null
                      : () => notifier.setCurrency(currency),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
