import 'package:intl/intl.dart';
import 'package:loan_buddy/core/currency/app_currency.dart';

class CurrencyFormatter {
  static String format(
    num amount,
    AppCurrency currency,
  ) {
    return NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: 2,
    ).format(amount);
  }
}