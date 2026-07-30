import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/app_currency.dart';
import 'package:loan_buddy/core/currency/currency_storage_service.dart';
import 'package:loan_buddy/core/currency/supported_currencies.dart';

final currencyProvider =
    NotifierProvider<CurrencyNotifier, AppCurrency>(
  CurrencyNotifier.new,
);

class CurrencyNotifier extends Notifier<AppCurrency> {
  final CurrencyStorageService _storage = CurrencyStorageService();

  @override
  AppCurrency build() {
    _loadCurrency();
    return SupportedCurrencies.inr;
  }

  Future<void> _loadCurrency() async {
    final code = await _storage.loadCurrencyCode();

    final currency = SupportedCurrencies.supported.firstWhere(
      (c) => c.code == code,
      orElse: () => SupportedCurrencies.inr,
    );

    state = currency;
  }

  Future<void> setCurrency(AppCurrency currency) async {
    if (state.code == currency.code) return;

    state = currency;
    await _storage.saveCurrencyCode(currency.code);
  }
}