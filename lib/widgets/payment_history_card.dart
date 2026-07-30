import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/core/utils/currency_formatter.dart';

class PaymentHistoryCard extends ConsumerWidget {
  final String paymentType;
  final double amount;
  final String date;

  const PaymentHistoryCard({
    super.key,
    required this.paymentType,
    required this.amount,
    required this.date,
  });

  Color get badgeColor {
    switch (paymentType.toLowerCase()) {
      case 'emi':
        return Colors.green;
      case 'part payment':
        return Colors.orange;
      case 'prepayment':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: badgeColor.withValues(alpha: 0.15),
          child: Icon(
            Icons.payments,
            color: badgeColor,
          ),
        ),
        title: Text(
          CurrencyFormatter.compact(
            amount,
            currency,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(paymentType),
        trailing: Text(date),
      ),
    );
  }
}