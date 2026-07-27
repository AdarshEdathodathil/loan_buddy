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

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
  settings: settings,
);
  }

  Future<void> scheduleMonthlyReminder({
    required int id,
    required String loanName,
    required double emiAmount,
    required int dueDay,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      dueDay,
      9,
    );

    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        dueDay,
        9,
      );
    }

    await _notifications.zonedSchedule(
  id: id,
  scheduledDate: scheduled,
  title: 'EMI Reminder',
  body: '$loanName EMI of ₹${emiAmount.toStringAsFixed(0)} is due today.',
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
    await _notifications.cancel(
  id: id,
);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    
  }

  
}