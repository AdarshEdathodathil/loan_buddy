import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';
import 'package:loan_buddy/features/payments/data/repositories/payment_repository.dart';

class PaymentService {
  final LoanRepository loanRepository;
  final PaymentRepository paymentRepository;

  PaymentService({
    required this.loanRepository,
    required this.paymentRepository,
  });

  Future<void> markEmiPaid({
    required int loanId,
    required double amount,
    String? remarks,
  }) async {
    await paymentRepository.addPayment(
      loanId: loanId,
      amount: amount,
      paymentDate: DateTime.now(),
      remarks: remarks,
    );

    await loanRepository.updateOutstandingBalance(
      loanId: loanId,
      paymentAmount: amount,
    );
  }
}