import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/secure_random.dart';

/// Test are copied from https://github.com/snggle/cryptography_utils/blob/master/test/utils/secure_random_test.dart
/// Because of the same implementation of SecureRandom class
void main() {
  group('Tests of SecureRandom.getBytes()', () {
    test('Should [return random bytes] with [length == 1] and values within the [range <0, 1>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 1, max: 1);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 1);

      expect(actualBytes.length, 1);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 1] and values within the [range <0, 2>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 1, max: 2);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 2);

      expect(actualBytes.length, 1);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 1] and values within the [range <0, 255>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 1, max: 255);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 255);

      expect(actualBytes.length, 1);
      expect(actualValuesInRangeBool, true);
    });

    // **************************************************************************************************

    test('Should [return random bytes] with [length == 2] and values within the [range <0, 1>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 2, max: 1);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 1);

      expect(actualBytes.length, 2);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 2] and values within the [range <0, 2>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 2, max: 2);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 2);

      expect(actualBytes.length, 2);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 2] and values within the [range <0, 255>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 2, max: 255);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 255);

      expect(actualBytes.length, 2);
      expect(actualValuesInRangeBool, true);
    });

    // **************************************************************************************************

    test('Should [return random bytes] with [length == 256] and values within the [range <0, 1>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 256, max: 1);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 1);

      expect(actualBytes.length, 256);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 256] and values within the [range <0, 2>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 256, max: 2);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 2);

      expect(actualBytes.length, 256);
      expect(actualValuesInRangeBool, true);
    });

    test('Should [return random bytes] with [length == 256] and values within the [range <0, 255>]', () {
      // Act
      Uint8List actualBytes = SecureRandom.getBytes(length: 256, max: 255);

      // Assert
      bool actualValuesInRangeBool = actualBytes.every((int byte) => byte >= 0 && byte <= 255);

      expect(actualBytes.length, 256);
      expect(actualValuesInRangeBool, true);
    });
  });
}