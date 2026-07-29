import 'package:flutter/material.dart';
import 'package:loan_buddy/features/analytics/models/loan_health.dart';

class LoanHealthCard extends StatelessWidget {
  final LoanHealth health;

  const LoanHealthCard({
    super.key,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    if (health.score >= 80) {
      color = Colors.green;
    } else if (health.score >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Health',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Text(
                  '${health.score}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                health.title,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                health.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}