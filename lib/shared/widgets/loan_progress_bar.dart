import 'package:flutter/material.dart';

class LoanProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final bool showPercentage;
  final Color? color;
  final Duration duration;

  const LoanProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
    this.showPercentage = true,
    this.color,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final value = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(height),
              child: LinearProgressIndicator(
                value: animatedValue,
                minHeight: height,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),

        if (showPercentage) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(value * 100).toStringAsFixed(0)}% Paid",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}