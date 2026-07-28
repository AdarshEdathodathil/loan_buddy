import 'package:flutter/material.dart';

class PaymentHistoryPreview extends StatelessWidget {
  const PaymentHistoryPreview({
    super.key,
    required this.loanId,
  });

  final int loanId;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text('Payment History'),
        ),
      ),
    );
  }
}