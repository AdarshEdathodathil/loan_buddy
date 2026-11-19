import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/payments/providers/payment_provider.dart';
import 'package:loan_buddy/features/notifications/providers/notification_provider.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';

final paymentControllerProvider = Provider<PaymentController>((ref) {
  return PaymentController(ref);
});

class PaymentController {
  final Ref ref;

  PaymentController(this.ref);

  Future<void> payEmi({
    required int loanId,
    required double amount,
    required DateTime paymentDate,
    required String paymentType,
    String? remarks,
  }) async {
    final paymentRepository = ref.read(paymentRepositoryProvider);

    final wasClosed = await paymentRepository.makePayment(
      loanId: loanId,
      amount: amount,
      paymentDate: paymentDate,
      paymentType: paymentType,
      remarks: remarks,
    );

    if (wasClosed) {
      await ref.read(notificationRepositoryProvider).cancelLoanReminder(loanId);
    }
  }

  Future<void> deletePayment(int paymentId) async {
    final loanId = await ref
        .read(paymentRepositoryProvider)
        .deletePayment(paymentId);
    if (loanId == null) return;

    final loan = await ref.read(loanRepositoryProvider).getLoan(loanId);
    if (loan != null && loan.reminderEnabled && !loan.isClosed) {
      await ref.read(notificationRepositoryProvider).scheduleLoanReminder(loan);
    }
  }
}
