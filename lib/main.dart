import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/core/startup/app_initializer.dart';

import 'app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await NotificationService.instance.initialize();

  final container = ProviderContainer();

  await const AppInitializer().initialize(container);

  runApp(
     UncontrolledProviderScope(
    container: container,
      child: LoanBuddyApp(),
    ),
  );
}