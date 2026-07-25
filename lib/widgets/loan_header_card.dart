import 'package:flutter/material.dart';

class LoanHeaderCard extends StatelessWidget {
  final String loanName;
  final String lender;
  final double totalAmount;
  final double outstandingAmount;

  const LoanHeaderCard({
    super.key,
    required this.loanName,
    required this.lender,
    required this.totalAmount,
    required this.outstandingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final paid = totalAmount - outstandingAmount;

    final progress = totalAmount == 0
        ? 0.0
        : (paid / totalAmount).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loanName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 4),

            Text(
              lender,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Outstanding Balance",
            ),

            const SizedBox(height: 8),

            Text(
              "₹${outstandingAmount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Paid ₹${paid.toStringAsFixed(0)}"),
                Text("Total ₹${totalAmount.toStringAsFixed(0)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}