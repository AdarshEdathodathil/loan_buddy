import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/loans/providers/loan_provider.dart';
import 'package:loan_buddy/features/payments/providers/payment_provider.dart';

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

    final loanRepository = ref.read(loanRepositoryProvider);

    await paymentRepository.addPayment(
      loanId: loanId,
      amount: amount,
      paymentDate: paymentDate,
      paymentType: paymentType,
      remarks: remarks,
    );

    await loanRepository.updateOutstandingBalance(
      loanId: loanId,
      paymentAmount: amount,
    );
  }
}