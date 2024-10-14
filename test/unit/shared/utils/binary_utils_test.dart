import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

void main() {
  group('Test of BinaryUtils.convertBinaryToBytes()', () {
    test('Should [return bytes] from given binary text', () {
      // Arrange
      String actualBinaryText = '0110100001100101011011000110110001101111';

      // Act
      Uint8List actualAsciiText = BinaryUtils.convertBinaryToBytes(actualBinaryText);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[104, 101, 108, 108, 111]);

      expect(actualAsciiText, expectedBytes);
    });
  });
}
