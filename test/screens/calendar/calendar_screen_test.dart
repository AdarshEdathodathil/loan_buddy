import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/core/database/app_database.dart';
import 'package:loan_buddy/core/database/database_provider.dart';
import 'package:loan_buddy/screens/calendar/calendar_screen.dart';

void main() {
  testWidgets('calendar marks EMI dates and lists the selected month loans', (
    tester,
  ) async {
    final now = DateTime.now();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database
        .into(database.loans)
        .insert(
          LoansCompanion.insert(
            name: 'Calendar test loan',
            lender: 'Test bank',
            loanType: 0,
            totalAmount: 100000,
            outstandingAmount: 80000,
            interestRate: 10,
            emiAmount: 8000,
            dueDay: 15,
            startDate: DateTime(2020),
            endDate: DateTime(now.year, now.month),
            reminderEnabled: const Value(false),
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: CalendarScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('EMI due date'), findsOneWidget);

    await tester.tap(find.byTooltip('Next month'));
    await tester.pump();
    expect(find.text('EMI due date'), findsNothing);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pump();
    expect(find.text('EMI due date'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();

    expect(find.text('Calendar test loan'), findsOneWidget);
    expect(find.text('1 due'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
