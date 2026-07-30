import 'app_currency.dart';

class SupportedCurrencies {
  static const inr = AppCurrency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    locale: 'en_IN',
  );

  static const usd = AppCurrency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    locale: 'en_US',
  );

  static const eur = AppCurrency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    locale: 'de_DE',
  );

  static const gbp = AppCurrency(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    locale: 'en_GB',
  );

  static const aed = AppCurrency(
    code: 'AED',
    symbol: 'د.إ',
    name: 'UAE Dirham',
    locale: 'ar_AE',
  );

  static const supported = [
    inr,
    usd,
    eur,
    gbp,
    aed,
  ];
}