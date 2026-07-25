import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:loan_buddy/screens/home/home_screen.dart';

class LoanBuddyApp extends StatelessWidget {
  const LoanBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Buddy',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}