import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xfff7f8fc),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.dark,
  );
}