import 'package:flutter/material.dart';

class PaymentHistoryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
          "₹${amount.toStringAsFixed(0)}",
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