import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/settings/screens/appearance_screen.dart';
import 'package:loan_buddy/features/settings/widgets/settings_section.dart';
import 'package:loan_buddy/features/settings/widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          SettingsSection(
            title: 'General',
            children: [
              SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Theme and display',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppearanceScreen()),
                  );
                },
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle: 'Indian Rupee (₹)',
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Preferences',
            children: [
              SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Reminder preferences',
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Data',
            children: [
              SettingsTile(
                icon: Icons.backup_outlined,
                title: 'Backup & Restore',
                subtitle: 'Export or import your data',
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'About',
            children: [
              SettingsTile(
                icon: Icons.info_outline,
                title: 'About Loan Buddy',
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
