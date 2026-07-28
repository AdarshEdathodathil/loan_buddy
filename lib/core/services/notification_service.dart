import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings: settings);
  }

  Future<void> scheduleMonthlyReminder({
    required int id,
    required String loanName,
    required double emiAmount,
    required int dueDay,
    required int reminderDaysBefore,
    required String reminderTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    final parts = reminderTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Due date for the current month
    var dueDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      dueDay,
      hour,
      minute,
    );

    // If this month's due date has already passed, use next month
    if (dueDate.isBefore(now)) {
      dueDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        dueDay,
        hour,
        minute,
      );
    }

    // Subtract reminder days
    final scheduled = dueDate.subtract(Duration(days: reminderDaysBefore));

    // if (scheduled.isBefore(now)) {
    //   scheduled = tz.TZDateTime(tz.local, now.year, now.month + 1, dueDay, 9);
    // }

    await _notifications.zonedSchedule(
      id: id,
      scheduledDate: scheduled,
      title: 'EMI Reminder',
      body: reminderDaysBefore == 0
          ? '$loanName EMI of ₹${emiAmount.toStringAsFixed(0)} is due today.'
          : '$loanName EMI of ₹${emiAmount.toStringAsFixed(0)} is due in $reminderDaysBefore day${reminderDaysBefore == 1 ? '' : 's'}.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'emi_reminders',
          'EMI Reminders',
          channelDescription: 'Monthly EMI reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id: id);
  }

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
