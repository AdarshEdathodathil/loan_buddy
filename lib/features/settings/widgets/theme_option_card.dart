import 'package:flutter/material.dart';

class ThemeOptionCard extends StatelessWidget {
  const ThemeOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: selected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      theme.colorScheme.primaryContainer,
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected
                      ? Icon(
                          Icons.check_circle,
                          key: const ValueKey(true),
                          color: theme.colorScheme.primary,
                        )
                      : const SizedBox(
                          key: ValueKey(false),
                          width: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}