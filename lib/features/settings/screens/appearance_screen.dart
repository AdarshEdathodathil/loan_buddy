import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/theme/theme_provider.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            // ignore: deprecated_member_use
            groupValue: themeMode,
            title: const Text('System'),
            subtitle: const Text('Follow your device settings'),
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setTheme(value);
              }
            },
          ),

          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            // ignore: deprecated_member_use
            groupValue: themeMode,
            title: const Text('Light'),
            subtitle: const Text('Always use the light theme'),
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setTheme(value);
              }
            },
          ),

          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            // ignore: deprecated_member_use
            groupValue: themeMode,
            title: const Text('Dark'),
            subtitle: const Text('Always use the dark theme'),
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setTheme(value);
              }
            },
          ),
        ],
      ),
    );
  }
}