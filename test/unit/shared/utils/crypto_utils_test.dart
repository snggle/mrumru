import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

void main() {
  group('Tests of CryptoUtils.calcChecksumFromBytes()', () {
    test('Should [return checksum] for given bytes', () {
      // Arrange
      // @formatter:off
      Uint8List actualBytes = Uint8List.fromList(<int>[
        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
        76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102,
        103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114
      ]);
      // @formatter:on

      // Act
      Uint8List actualChecksum = CryptoUtils.calcChecksum(bytes: actualBytes);

      // Assert
      Uint8List expectedChecksum = Uint8List.fromList(<int>[3, 52, 94, 221, 115, 127, 181, 28, 158, 50, 128, 132, 207, 107, 82, 43]);
      expect(actualChecksum, expectedChecksum);
    });
  });
}
