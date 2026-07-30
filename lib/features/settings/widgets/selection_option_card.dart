import 'package:flutter/material.dart';

class SelectionOptionCard extends StatelessWidget {
  const SelectionOptionCard({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  }) : assert(
          icon != null || leading != null,
          'Either icon or leading must be provided.',
        );

  final IconData? icon;
  final String? leading;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: icon != null
                        ? Icon(
                            icon,
                            color: theme.colorScheme.primary,
                          )
                        : Text(
                            leading!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: selected
                        ? Icon(
                            Icons.check_circle,
                            key: const ValueKey('selected'),
                            color: theme.colorScheme.primary,
                          )
                        : const SizedBox(
                            key: ValueKey('unselected'),
                            width: 24,
                            height: 24,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}