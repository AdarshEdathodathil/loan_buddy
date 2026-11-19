/// Centralized decimal normalization for currencies with two minor-unit digits.
///
/// SQLite values are still migrated from legacy REAL columns, so every write
/// crosses this boundary to avoid accumulating binary floating-point residue.
abstract final class MoneyMath {
  static const int minorUnitsPerMajor = 100;
  static const double tolerance = 0.005;

  static int toMinorUnits(num amount) => (amount * minorUnitsPerMajor).round();

  static double fromMinorUnits(int amount) => amount / minorUnitsPerMajor;

  static double normalize(num amount) => fromMinorUnits(toMinorUnits(amount));

  static bool isZero(num amount) => amount.abs() < tolerance;

  static bool isGreaterThan(num left, num right) => left - right > tolerance;
}
