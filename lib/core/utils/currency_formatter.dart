import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/app_currency.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    num value,
    AppCurrency currency,
  ) {
    return NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: 2,
    ).format(value);
  }

  static String compact(
    num value,
    AppCurrency currency,
  ) {
    final abs = value.abs();

    // Indian numbering system
    if (currency.code == 'INR') {
      if (abs >= 10000000) {
        return '${currency.symbol}${(value / 10000000).toStringAsFixed(2)} Cr';
      }

      if (abs >= 100000) {
        return '${currency.symbol}${(value / 100000).toStringAsFixed(2)} L';
      }
    }

    // International numbering system
    return NumberFormat.compactCurrency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: 2,
    ).format(value);
  }
}