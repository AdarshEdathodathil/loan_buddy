import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class CurrencyText extends ConsumerWidget  {
  const CurrencyText(
    this.amount, {
    super.key,
    this.fontSize = 28,
    this.fontWeight = FontWeight.bold,
    this.color,
  });

  final double amount;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Text(
      CurrencyFormatter.format(amount, currency),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}