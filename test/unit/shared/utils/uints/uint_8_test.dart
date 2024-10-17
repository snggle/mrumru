import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of Uint8.fromBytes() ', () {
    test('Should [return UintReminder] from given Uint8List', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[3]);

      // Act
      UintReminder<Uint8> actualUint8 = Uint8.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint8> expectedUint8 = UintReminder<Uint8>(
        Uint8(Uint8List.fromList(<int>[3])),
        Uint8List.fromList(<int>[]),
      );

      expect(actualUint8, expectedUint8);
    });

    test('Should [return UintReminder] from given Uint8List', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[3, 2, 2, 3, 4, 1]);

      // Act
      UintReminder<Uint8> actualUint8 = Uint8.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint8> expectedUint8 = UintReminder<Uint8>(
        Uint8(Uint8List.fromList(<int>[3])),
        Uint8List.fromList(<int>[2, 2, 3, 4, 1]),
      );

      expect(actualUint8, expectedUint8);
    });
  });

  group('Test of Uint16.fromInt()', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      int actualValue = 3;

      // Act
      Uint8 actualUint8 = Uint8.fromInt(actualValue);

      // Assert
      Uint8 expectedUint8 = Uint8(Uint8List.fromList(<int>[3]));

      expect(actualUint8, expectedUint8);
    });
  });

  group('Test of Uint16.toInt()', () {
    test('Should [return int] from given bytes', () {
      // Arrange
      Uint8 actualUint8 = Uint8(Uint8List.fromList(<int>[3]));

      // Act
      int actualValue = actualUint8.toInt();

      // Assert
      int expectedValue = 3;

      expect(actualValue, expectedValue);
    });
  });
}
