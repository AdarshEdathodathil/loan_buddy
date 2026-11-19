import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/database/database_provider.dart';
import 'package:loan_buddy/features/loans/presentation/add_loan/add_loan_screen.dart';

void main() {
  testWidgets('edit wizard shows the existing loan values on first build', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final loan = Loan(
      id: 7,
      name: 'HDFC personal loan',
      lender: 'HDFC Bank',
      loanType: 0,
      totalAmount: 100000,
      outstandingAmount: 80000,
      interestRate: 10.5,
      emiAmount: 8000,
      dueDay: 1,
      startDate: DateTime(2026, 1),
      endDate: DateTime(2027, 1),
      notes: 'Existing account',
      reminderEnabled: false,
      reminderDaysBefore: 1,
      reminderTime: '09:00',
      isClosed: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(home: AddLoanScreen(loan: loan)),
      ),
    );
    await tester.pump();

    expect(_fieldText(tester, 'Loan name'), 'HDFC personal loan');
    expect(_fieldText(tester, 'Lender'), 'HDFC Bank');

    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pump();

    expect(_fieldText(tester, 'Original loan amount'), '100000.0');
    expect(_fieldText(tester, 'Outstanding balance'), '80000.0');
    expect(_fieldText(tester, 'Annual interest rate'), '10.5');
  });
}

String _fieldText(WidgetTester tester, String label) {
  final field = find.widgetWithText(TextFormField, label);
  final editable = find.descendant(
    of: field,
    matching: find.byType(EditableText),
  );
  return tester.widget<EditableText>(editable).controller.text;
}
