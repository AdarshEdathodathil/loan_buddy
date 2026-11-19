import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/currency/currency_provider.dart';
import 'package:loan_buddy/features/settings/screens/about_loan_buddy_screen.dart';
import 'package:loan_buddy/features/settings/screens/appearance_screen.dart';
import 'package:loan_buddy/features/settings/screens/currency_screen.dart';
import 'package:loan_buddy/features/settings/widgets/settings_section.dart';
import 'package:loan_buddy/features/settings/widgets/settings_tile.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        top: false,
        child: AppPage(
          maxWidth: 760,
          child: ListView(
            children: [
              _PrivacyBanner(),
              const SizedBox(height: 28),
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
                        MaterialPageRoute(
                          builder: (_) => const AppearanceScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.currency_exchange,
                    title: 'Currency',
                    subtitle: selectedCurrency.name,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CurrencyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Preferences',
                children: [
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Permissions and per-loan reminders',
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('EMI reminders'),
                          content: const Text(
                            'Reminder timing can be configured from each loan’s '
                            'details screen.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Close'),
                            ),
                            FilledButton(
                              onPressed: () async {
                                final granted = await NotificationService
                                    .instance
                                    .requestPermissions();
                                if (!granted) return;
                                await NotificationService.instance
                                    .showTestNotification();
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                }
                              },
                              child: const Text('Send test'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Data',
                children: [
                  SettingsTile(
                    icon: Icons.backup_outlined,
                    title: 'Backup & Restore',
                    subtitle: 'Under development',
                    trailing: const Icon(Icons.schedule),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutLoanBuddyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 28,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Private by design', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Loan data is stored locally. Device-level backups depend on '
                  'your operating-system settings.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
