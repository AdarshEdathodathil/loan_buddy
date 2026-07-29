import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/notifications/providers/notification_provider.dart';

class AppInitializer {
  const AppInitializer();

  Future<void> initialize(ProviderContainer container) async {
    final loanRepository = container.read(loanRepositoryProvider);
    final notificationRepository = container.read(
      notificationRepositoryProvider,
    );

    final loans = await loanRepository.getLoans();

    await notificationRepository.rescheduleAllLoans(loans);
  }
}