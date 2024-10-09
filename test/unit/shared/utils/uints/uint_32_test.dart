import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of Uint32.fromBytes()', () {
    test('Should return [bytes] from given Uint8List', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      // Act
      UintReminder<Uint32> actualUint32 = Uint32.fromBytes(actualBytes);

      // Assert
      Uint32 expectedUint32 = Uint32(Uint8List.fromList(<int>[0, 0, 0, 3]));

      expect(actualUint32.value, expectedUint32);
    });
  });

  group('Test of Uint32.fromInt()', () {
    test('Should return [bytes] from given value', () {
      // Arrange
      int actualValue = 3;

      // Act
      Uint32 actualUint32 = Uint32.fromInt(actualValue);

      // Assert
      Uint32 expectedUint32 = Uint32(Uint8List.fromList(<int>[0, 0, 0, 3]));

      expect(actualUint32, expectedUint32);
    });
  });

  group('Test of Uint32.toInt()', () {
    test('Should return [int] from given bytes', () {
      // Arrange
      Uint32 actualUint32 = Uint32(Uint8List.fromList(<int>[0, 0, 0, 3]));

      // Act
      int actualValue = actualUint32.toInt();

      // Assert
      int expectedValue = 3;

      expect(actualValue, expectedValue);
    });
  });
}
