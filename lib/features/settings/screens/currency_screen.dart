import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/currency/supported_currencies.dart';
import 'package:loan_buddy/features/settings/widgets/selection_option_card.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyProvider);
    final notifier = ref.read(currencyProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Currency')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your preferred currency',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This currency will be used throughout Loan Buddy.',
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
                onTap: () => notifier.setCurrency(currency),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
