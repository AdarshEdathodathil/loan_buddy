import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/core/constants/payment_type.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/payments/data/repositories/payment_repository.dart';

void main() {
  late AppDatabase database;
  late PaymentRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = PaymentRepository(database);
  });

  tearDown(() => database.close());

  test('records a payment and updates the balance atomically', () async {
    final loanId = await _insertLoan(database);

    final wasClosed = await repository.makePayment(
      loanId: loanId,
      amount: 200,
      paymentDate: DateTime(2026, 1, 2),
      paymentType: PaymentType.emi,
    );

    final loan = await (database.select(
      database.loans,
    )..where((row) => row.id.equals(loanId))).getSingle();
    final payments = await repository.watchPayments(loanId).first;

    expect(wasClosed, isFalse);
    expect(loan.outstandingAmount, 800);
    expect(payments.single.amount, 200);
  });

  test('rejects an overpayment without changing stored data', () async {
    final loanId = await _insertLoan(database);

    await expectLater(
      repository.makePayment(
        loanId: loanId,
        amount: 1200,
        paymentDate: DateTime(2026, 1, 2),
        paymentType: PaymentType.emi,
      ),
      throwsArgumentError,
    );

    final loan = await (database.select(
      database.loans,
    )..where((row) => row.id.equals(loanId))).getSingle();
    final payments = await repository.watchPayments(loanId).first;

    expect(loan.outstandingAmount, 1000);
    expect(payments, isEmpty);
  });

  test('deleting a payment restores the outstanding balance', () async {
    final loanId = await _insertLoan(database);
    await repository.makePayment(
      loanId: loanId,
      amount: 250,
      paymentDate: DateTime(2026, 1, 2),
      paymentType: PaymentType.partPayment,
    );
    final payment = (await repository.watchPayments(loanId).first).single;

    await repository.deletePayment(payment.id);

    final loan = await (database.select(
      database.loans,
    )..where((row) => row.id.equals(loanId))).getSingle();
    final payments = await repository.watchPayments(loanId).first;

    expect(loan.outstandingAmount, 1000);
    expect(loan.isClosed, isFalse);
    expect(payments, isEmpty);
  });

  test('a partial EMI does not mark the installment as fully paid', () async {
    final loanId = await _insertLoan(database);

    await repository.makePayment(
      loanId: loanId,
      amount: 40,
      paymentDate: DateTime(2026, 1, 2),
      paymentType: PaymentType.emi,
    );

    expect(await repository.getNextUnpaidEmiMonth(loanId), DateTime(2026));

    await repository.makePayment(
      loanId: loanId,
      amount: 60,
      paymentDate: DateTime(2026, 1, 3),
      paymentType: PaymentType.emi,
    );

    expect(await repository.getNextUnpaidEmiMonth(loanId), DateTime(2026, 2));
  });

  test('database rejects a payment for a missing loan', () async {
    await expectLater(
      database
          .into(database.payments)
          .insert(
            PaymentsCompanion.insert(
              loanId: 999,
              amount: 10,
              paymentDate: DateTime(2026),
              emiForMonth: DateTime(2026),
            ),
          ),
      throwsA(anything),
    );
  });

  test('deleting a loan cascades its payment history', () async {
    final loanId = await _insertLoan(database);
    await repository.makePayment(
      loanId: loanId,
      amount: 100,
      paymentDate: DateTime(2026, 1, 2),
      paymentType: PaymentType.emi,
    );

    await (database.delete(
      database.loans,
    )..where((loan) => loan.id.equals(loanId))).go();

    expect(await repository.watchPayments(loanId).first, isEmpty);
  });
}

Future<int> _insertLoan(AppDatabase database) {
  return database
      .into(database.loans)
      .insert(
        LoansCompanion.insert(
          name: 'Test loan',
          lender: 'Test lender',
          loanType: 0,
          totalAmount: 1000,
          outstandingAmount: 1000,
          interestRate: 10,
          emiAmount: 100,
          dueDay: 1,
          startDate: DateTime(2026),
          endDate: DateTime(2027),
          reminderEnabled: const Value(false),
        ),
      );
}
