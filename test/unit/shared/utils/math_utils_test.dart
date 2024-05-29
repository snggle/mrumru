import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/math_utils.dart';

void main() {
  group('Test of MathUtils.sinc()', () {
    test('Should return sinc value for given number (2.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(2.0);

      // Assert
      double expectedCalculatedValue = -3.8981718325193755e-17;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });

    test('Should return sinc value for given number (-1.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(-1.0);

      // Assert
      double expectedCalculatedValue = 3.8981718325193755e-17;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });

    test('Should return sinc value for given number (-10.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(-10.0);

      // Assert
      double expectedCalculatedValue = -3.898171832519376e-17;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });

    test('Should return sinc value for given number (0.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(0.0);

      // Assert
      double expectedCalculatedValue = 1.0;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });

    test('Should return sinc value for given number (1.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(1.0);

      // Assert
      double expectedCalculatedValue = 3.8981718325193755e-17;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });

    test('Should return sinc value for given number (10.0)', () {
      // Act
      double actualCalculatedValue = MathUtils.sinc(10.0);

      // Assert
      double expectedCalculatedValue = -3.898171832519376e-17;
      expect(actualCalculatedValue, expectedCalculatedValue);
    });
  });
}
