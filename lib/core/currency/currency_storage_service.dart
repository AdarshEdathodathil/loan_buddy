import 'package:shared_preferences/shared_preferences.dart';

class CurrencyStorageService {
  static const _key = 'selected_currency';

  Future<String> loadCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'INR';
  }

  Future<void> saveCurrencyCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}