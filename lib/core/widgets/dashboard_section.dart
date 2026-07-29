import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 28),
      ],
    );
  }
}