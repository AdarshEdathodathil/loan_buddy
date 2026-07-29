import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/theme/theme_storage_service.dart';

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  final ThemeStorageService _storage = ThemeStorageService();

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final savedTheme = await _storage.loadThemeMode();
    state = savedTheme;
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (state == mode) return;

    state = mode;
    await _storage.saveThemeMode(mode);
  }
}