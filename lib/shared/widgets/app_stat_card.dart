import 'package:flutter/material.dart';
import 'package:loan_buddy/core/theme/app_spacing.dart';

class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: iconColor.withValues(alpha: 0.12),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                value,
                style: theme.textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}