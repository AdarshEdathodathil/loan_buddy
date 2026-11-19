import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:loan_buddy/core/logger/app_logger.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/core/startup/app_initializer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        AppLogger.error(
          'Unhandled Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
      };
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppLogger.error(
          'Unhandled platform error',
          error: error,
          stackTrace: stackTrace,
        );
        return true;
      };

      tz.initializeTimeZones();
      try {
        final timezoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneName));
      } catch (error, stackTrace) {
        AppLogger.warning(
          'Could not resolve the local timezone; using the safe default',
          error: error,
          stackTrace: stackTrace,
        );
      }

      try {
        await NotificationService.instance.initialize();
      } catch (error, stackTrace) {
        AppLogger.warning(
          'Notification initialization failed; continuing without reminders',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final container = ProviderContainer();
      runApp(
        UncontrolledProviderScope(container: container, child: LoanBuddyApp()),
      );

      unawaited(_initializeAfterLaunch(container));
    },
    (error, stackTrace) {
      AppLogger.error(
        'Unhandled application error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

Future<void> _initializeAfterLaunch(ProviderContainer container) async {
  try {
    await const AppInitializer().initialize(container);
  } catch (error, stackTrace) {
    AppLogger.warning(
      'Background app initialization did not complete',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
