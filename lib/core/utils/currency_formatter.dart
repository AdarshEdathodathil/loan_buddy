import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num value) {
    return _currency.format(value);
  }

  static String compact(num value) {
    final abs = value.abs();

    if (abs >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(2)} Cr';
    }

    if (abs >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(2)} L';
    }

    return _currency.format(value);
  }
}