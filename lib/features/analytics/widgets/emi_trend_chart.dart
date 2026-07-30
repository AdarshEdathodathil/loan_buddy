import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/features/analytics/models/monthly_emi_data.dart';

class EmiTrendChart extends StatelessWidget {
  const EmiTrendChart({
    super.key,
    required this.data,
  });

  final List<MonthlyEmiData> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No payment history available'),
          ),
        ),
      );
    }

    final maxY =
        data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.show_chart),
                SizedBox(width: 8),
                Text(
                  "EMI Trend",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY * 1.2,

                  gridData: const FlGridData(show: true),

                  borderData: FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index >= data.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[index].month,
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 55,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            NumberFormat.compactCurrency(
                              symbol: '',
                              decimalDigits: 0,
                            ).format(value),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      spots: List.generate(
                        data.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          data[index].amount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}