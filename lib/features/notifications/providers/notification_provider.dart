import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/services/notification_service.dart';
import 'package:loan_buddy/features/notifications/data/repositories/notification_repository.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository(NotificationService.instance);
});