import 'package:flutter/material.dart';
import 'quick_action_button.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddLoan;
  final VoidCallback onCalendar;
  final VoidCallback onAnalytics;
  final VoidCallback onSettings;

  const QuickActions({
    super.key,
    required this.onAddLoan,
    required this.onCalendar,
    required this.onAnalytics,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        QuickActionButton(
          icon: Icons.add_circle_outline,
          label: "Add Loan",
          onTap: onAddLoan,
        ),
        QuickActionButton(
          icon: Icons.calendar_month,
          label: "Calendar",
          onTap: onCalendar,
        ),
        QuickActionButton(
          icon: Icons.bar_chart,
          label: "Analytics",
          onTap: onAnalytics,
        ),
        QuickActionButton(
          icon: Icons.settings,
          label: "Settings",
          onTap: onSettings,
        ),
      ],
    );
  }
}