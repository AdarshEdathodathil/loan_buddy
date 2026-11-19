import 'package:flutter_test/flutter_test.dart';
import 'package:loan_buddy/core/money/money_math.dart';

void main() {
  test('normalizes floating-point residue to minor units', () {
    expect(MoneyMath.normalize(0.1 + 0.2), 0.3);
    expect(MoneyMath.toMinorUnits(19.999), 2000);
  });

  test('uses half-minor-unit tolerance for comparisons', () {
    expect(MoneyMath.isZero(0.004), isTrue);
    expect(MoneyMath.isGreaterThan(10.01, 10), isTrue);
    expect(MoneyMath.isGreaterThan(10.001, 10), isFalse);
  });
}
