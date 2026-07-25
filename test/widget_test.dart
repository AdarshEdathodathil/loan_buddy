import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loan_buddy/app.dart';

void main() {
  testWidgets('Loan Buddy app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LoanBuddyApp(),
      ),
    );

    expect(find.text('Loan Buddy'), findsOneWidget);
  });
}