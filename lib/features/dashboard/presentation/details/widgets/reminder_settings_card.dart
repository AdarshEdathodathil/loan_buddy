import 'package:flutter/material.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/services/notification_service.dart';

class ReminderSettingsCard extends StatelessWidget {
  const ReminderSettingsCard({
    super.key,
    required this.loan,
    required this.onSave,
  });

  final Loan loan;
  final Future<void> Function({
    required bool enabled,
    required int daysBefore,
    required String time,
  })
  onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('EMI reminder'),
            subtitle: Text(
              loan.reminderEnabled
                  ? _description(loan.reminderDaysBefore, loan.reminderTime)
                  : 'Reminder disabled',
            ),
            value: loan.reminderEnabled,
            onChanged: (enabled) async {
              if (!enabled) {
                await onSave(
                  enabled: false,
                  daysBefore: loan.reminderDaysBefore,
                  time: loan.reminderTime,
                );
                return;
              }
              if (!context.mounted) return;
              final granted = await NotificationService.instance
                  .requestPermissions();
              if (!context.mounted) return;
              if (!granted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Allow notifications in system settings to enable reminders.',
                    ),
                  ),
                );
                return;
              }
              await _editReminder(context, enabled: true);
            },
          ),
          if (loan.reminderEnabled)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _editReminder(context, enabled: true),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Change reminder'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _editReminder(
    BuildContext context, {
    required bool enabled,
  }) async {
    var daysBefore = loan.reminderDaysBefore;
    final timeParts = loan.reminderTime.split(':');
    var time = TimeOfDay(
      hour: int.tryParse(timeParts.first) ?? 9,
      minute: timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0,
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('EMI reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: daysBefore,
                decoration: const InputDecoration(labelText: 'Remind me'),
                items: const [0, 1, 2, 3, 7]
                    .map(
                      (days) => DropdownMenuItem(
                        value: days,
                        child: Text(
                          days == 0
                              ? 'On the due date'
                              : '$days day${days == 1 ? '' : 's'} before',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => daysBefore = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reminder time'),
                subtitle: Text(time.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final selected = await showTimePicker(
                    context: dialogContext,
                    initialTime: time,
                  );
                  if (selected != null) {
                    setDialogState(() => time = selected);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (shouldSave != true) return;
    final formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    await onSave(enabled: enabled, daysBefore: daysBefore, time: formattedTime);
  }

  String _description(int daysBefore, String time) {
    final timing = daysBefore == 0
        ? 'On the due date'
        : '$daysBefore day${daysBefore == 1 ? '' : 's'} before';
    return '$timing at $time';
  }
}
