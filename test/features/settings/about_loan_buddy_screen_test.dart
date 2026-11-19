import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/features/settings/screens/about_loan_buddy_screen.dart';

void main() {
  testWidgets('about page presents the app feature catalogue', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutLoanBuddyScreen()));

    expect(find.text('Loan Buddy'), findsOneWidget);
    expect(find.text('Loan management'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Insights and payoff planning'),
      450,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Insights and payoff planning'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
