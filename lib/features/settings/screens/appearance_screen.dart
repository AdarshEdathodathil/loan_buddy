import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/theme/theme_provider.dart';
import 'package:loan_buddy/features/settings/widgets/theme_option_card.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your theme',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select how Loan Buddy looks on your device.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          ThemeOptionCard(
            icon: Icons.brightness_auto,
            title: 'System Default',
            subtitle: 'Follow your device settings',
            selected: themeMode == ThemeMode.system,
            onTap: () {
              themeNotifier.setTheme(ThemeMode.system);
            },
          ),

          ThemeOptionCard(
            icon: Icons.light_mode,
            title: 'Light',
            subtitle: 'Always use the light theme',
            selected: themeMode == ThemeMode.light,
            onTap: () {
              themeNotifier.setTheme(ThemeMode.light);
            },
          ),

          ThemeOptionCard(
            icon: Icons.dark_mode,
            title: 'Dark',
            subtitle: 'Always use the dark theme',
            selected: themeMode == ThemeMode.dark,
            onTap: () {
              themeNotifier.setTheme(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}
