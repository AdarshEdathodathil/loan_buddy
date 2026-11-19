import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/core/currency/supported_currencies.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/features/loans/data/repositories/loan_repository.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/state/add_loan_notifier.dart';

void main() {
  late AppDatabase database;
  late AddLoanNotifier notifier;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    notifier = AddLoanNotifier(
      LoanRepository(database),
      SupportedCurrencies.inr,
    );
  });

  tearDown(() async {
    notifier.dispose();
    await database.close();
  });

  test('requires a loan name and lender', () {
    expect(notifier.validateBasicInfo(), 'Enter a loan name.');

    notifier.updateLoanName('Home loan');
    expect(notifier.validateBasicInfo(), 'Enter the lender name.');

    notifier.updateLender('Example Bank');
    expect(notifier.validateBasicInfo(), isNull);
  });

  test('rejects an outstanding balance above the principal', () {
    notifier.updateTotalAmount(1000);
    notifier.updateOutstanding(1200);
    notifier.updateInterest(10);

    expect(
      notifier.validateLoanDetails(),
      'Outstanding amount cannot exceed the total amount.',
    );
  });

  test('rejects invalid dates and an EMI below monthly interest', () {
    notifier.updateTotalAmount(100000);
    notifier.updateOutstanding(100000);
    notifier.updateInterest(12);
    notifier.updateEmi(500);
    notifier.updateDueDay(1);
    notifier.updateStartDate(DateTime(2026, 2));
    notifier.updateEndDate(DateTime(2026, 1));

    expect(
      notifier.validateEmiDetails(),
      'End date must be after the start date.',
    );

    notifier.updateEndDate(DateTime(2036));
    expect(
      notifier.validateEmiDetails(),
      'EMI must be greater than the monthly interest.',
    );
  });
}
