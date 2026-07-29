import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loan_buddy/features/analytics/models/analytics_data.dart';

class LoanHealthChart extends StatelessWidget {
  final AnalyticsData data;

  const LoanHealthChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final paid = data.totalPaid;
    final outstanding = data.totalOutstanding;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Loan Health",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 55,
                  sectionsSpace: 4,
                  sections: [
                    PieChartSectionData(
                      value: outstanding,
                      color: Colors.deepPurple,
                      radius: 55,
                      title:
                          "${((outstanding / data.totalBorrowed) * 100).toStringAsFixed(0)}%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: paid,
                      color: Colors.green,
                      radius: 55,
                      title:
                          "${((paid / data.totalBorrowed) * 100).toStringAsFixed(0)}%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _Legend(
                  color: Colors.deepPurple,
                  text: "Outstanding",
                ),
                _Legend(
                  color: Colors.green,
                  text: "Paid",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}