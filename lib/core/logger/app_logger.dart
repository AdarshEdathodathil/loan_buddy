import 'dart:developer' as developer;

/// Minimal production-safe logging facade.
///
/// Never include loan names, lenders, balances, notes, or document contents in
/// log messages. Those values are intentionally excluded from this API.
abstract final class AppLogger {
  static const _name = 'loan_buddy';

  static void info(String message) {
    developer.log(message, name: _name);
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
