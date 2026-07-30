import 'package:flutter/foundation.dart';

@immutable
class AppCurrency {
  final String code;
  final String symbol;
  final String name;
  final String locale;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCurrency &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}