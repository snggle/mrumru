import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';

void main() {
  group('Test of BigIntUtils.decode()', () {
    test('Should return decoded big int from given bytes', () {
      // Arrange
      List<int> actualBytes = <int>[0, 0, 0, 0, 0, 0, 0, 1];

      // Act
      BigInt actualDecodedInt = BigIntUtils.decode(actualBytes);

      // Assert
      BigInt expectedInt = BigInt.from(1);

      expect(actualDecodedInt, expectedInt);
    });
  });

  group('Test of BigIntUtils.encode()', () {
    test('should return list of encoded big int to bytes', () {
      // Arrange
      BigInt actualValue = BigInt.from(1);

      // Act
      Uint8List actualEncodedBytes = BigIntUtils.encode(actualValue, 8);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 0, 0, 0, 0, 1]);

      expect(actualEncodedBytes, expectedBytes);
    });
  });
}
