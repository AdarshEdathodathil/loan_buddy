import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const _scheduledReminderSlots = 24;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(settings: settings);
  }

  Future<void> scheduleMonthlyReminder({
    required int id,
    required String loanName,
    required String formattedEmiAmount,
    required int dueDay,
    required int reminderDaysBefore,
    required String reminderTime,
  }) async {
    await cancelReminder(id);

    final now = tz.TZDateTime.now(tz.local);

    final parts = reminderTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    var scheduledCount = 0;
    var monthOffset = 0;
    while (scheduledCount < _scheduledReminderSlots) {
      final month = DateTime(now.year, now.month + monthOffset);
      final lastDay = DateTime(month.year, month.month + 1, 0).day;
      final effectiveDueDay = dueDay.clamp(1, lastDay);
      final dueDate = tz.TZDateTime(
        tz.local,
        month.year,
        month.month,
        effectiveDueDay,
        hour,
        minute,
      );
      final scheduled = dueDate.subtract(Duration(days: reminderDaysBefore));
      monthOffset++;

      if (!scheduled.isAfter(now)) continue;

      await _notifications.zonedSchedule(
        id: _scheduledId(id, scheduledCount),
        scheduledDate: scheduled,
        title: 'EMI Reminder',
        body: reminderDaysBefore == 0
            ? '$loanName EMI of $formattedEmiAmount is due today.'
            : '$loanName EMI of $formattedEmiAmount is due in '
                  '$reminderDaysBefore day${reminderDaysBefore == 1 ? '' : 's'}.',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'emi_reminders',
            'EMI Reminders',
            channelDescription: 'Monthly EMI reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      scheduledCount++;
    }
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id: id);
    for (var slot = 0; slot < _scheduledReminderSlots; slot++) {
      await _notifications.cancel(id: _scheduledId(id, slot));
    }
  }

  Future<bool> requestPermissions() async {
    final androidGranted = await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final iosGranted = await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final macosGranted = await _notifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return (androidGranted ?? true) &&
        (iosGranted ?? true) &&
        (macosGranted ?? true);
  }

  int _scheduledId(int loanId, int slot) => loanId * 100 + slot;

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  Future<void> showTestNotification() async {
    await _notifications.show(
      id: 999999,
      title: 'Loan Buddy',
      body: 'Notifications are working correctly! 🎉',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'emi_reminders',
          'EMI Reminders',
          channelDescription: 'Monthly EMI reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
