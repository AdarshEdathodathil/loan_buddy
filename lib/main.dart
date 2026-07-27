import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await NotificationService.instance.initialize();

  runApp(
    const ProviderScope(
      child: LoanBuddyApp(),
    ),
  );
}