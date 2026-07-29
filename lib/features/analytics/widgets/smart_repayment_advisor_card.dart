import 'package:flutter/material.dart';
import 'package:loan_buddy/features/analytics/models/repayment_advice.dart';

class SmartRepaymentAdvisorCard extends StatelessWidget {
  final RepaymentAdvice advice;

  const SmartRepaymentAdvisorCard({
    super.key,
    required this.advice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Text(
                  'Smart Repayment Advisor',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              advice.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.account_balance),
              ),
              title: Text(advice.recommendedLoan.name),
              subtitle: Text(advice.recommendedLoan.lender),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendation Score',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${advice.score.toStringAsFixed(1)} / 100',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              advice.reason,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            const Text(
              'Why this loan?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...advice.highlights.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: const Icon(Icons.priority_high),
                label: Text(
                  advice.priority.name.toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}