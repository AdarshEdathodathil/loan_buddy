import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await notifications.initialize(
  settings: settings,
);

    final androidPlugin = notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    await initializeTimeZone();
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'loan_buddy_channel',
      'Loan Buddy',
      channelDescription: 'EMI Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await notifications.show(
      id: 1,
      title: 'Loan Buddy',
      body: 'Notifications are working successfully 🎉',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> scheduleTestNotification() async {
  final scheduledTime =
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30));

  const androidDetails = AndroidNotificationDetails(
    'loan_buddy_channel',
    'Loan Buddy',
    channelDescription: 'EMI Reminder Notifications',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  await notifications.zonedSchedule(
  id: 100,
  title: 'Loan Buddy',
  body: 'Scheduled notification',
  scheduledDate: scheduledTime,
  notificationDetails: const NotificationDetails(
    android: androidDetails,
  ),
  androidScheduleMode: AndroidScheduleMode.inexact,
);

  final pending = await notifications.pendingNotificationRequests();

  debugPrint("Pending count: ${pending.length}");

  for (final p in pending) {
    debugPrint("ID: ${p.id}, Title: ${p.title}");
  }
}

  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
  }
}
