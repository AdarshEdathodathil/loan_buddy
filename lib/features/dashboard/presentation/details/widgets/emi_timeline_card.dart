import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_buddy/core/database/app_database.dart';

class EmiTimelineCard extends StatelessWidget {
  const EmiTimelineCard({
    super.key,
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final months = _generateMonths();

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
            Text(
              "EMI Timeline",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 20),

            ...months.map(
              (date) {
                final now = DateTime.now();

                final paid = date.isBefore(
                  DateTime(now.year, now.month, 1),
                );

                final next =
                    date.year == now.year &&
                    date.month == now.month;

                IconData icon;
                Color color;
                String status;

                if (paid) {
                  icon = Icons.check_circle;
                  color = Colors.green;
                  status = "Paid";
                } else if (next) {
                  icon = Icons.schedule;
                  color = Colors.orange;
                  status = "Next";
                } else {
                  icon = Icons.radio_button_unchecked;
                  color = Colors.grey;
                  status = "Upcoming";
                }

                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(
                    DateFormat('MMM yyyy').format(date),
                  ),
                  trailing: Text(status),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _generateMonths() {
    final months = <DateTime>[];

    DateTime current = DateTime(
      loan.startDate.year,
      loan.startDate.month,
    );

    while (!current.isAfter(loan.endDate)) {
      months.add(current);

      current = DateTime(
        current.year,
        current.month + 1,
      );
    }

    return months;
  }
}