import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/theme/app_theme.dart';
import 'package:loan_buddy/core/theme/theme_provider.dart';
import 'package:loan_buddy/screens/home/home_screen.dart';

class LoanBuddyApp extends ConsumerWidget {
  const LoanBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Buddy',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}