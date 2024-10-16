import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';

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
  group('Test of BinaryUtils.frameToBinaryString()', () {
    test('Should [return binary] from given data frame', () {
      // Arrange
      DataFrame actualDataFrame = DataFrame.fromValues(
        frameIndex: 1,
        data: Uint8List.fromList(<int>[1, 2, 3, 4]),
      );

      // Act
      String actualBinaryString = BinaryUtils.frameToBinaryString(actualDataFrame);

      // Assert
      String expectedBinaryString = '00000000000000010000000000000100000000010000001000000011000001000100011000100111';

      expect(actualBinaryString, expectedBinaryString);
    });

    test('Should [return binary] from given meta data frame', () {
      // Arrange
      MetadataFrame actualDataFrame = MetadataFrame.fromValues(
        frameIndex: 1,
        data: Uint8List.fromList(<int>[]),
        frameProtocolID: FrameProtocolID(
            compressionMethod: Uint8.fromInt(0), encodingMethod: Uint8.fromInt(0), protocolType: Uint8.fromInt(0), versionNumber: Uint8.fromInt(1)),
        sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
        dataFrames: <DataFrame>[],
      );

      // Act
      String actualBinaryString = BinaryUtils.frameToBinaryString(actualDataFrame);

      // Assert
      String expectedBinaryString =
          '0000000000000001000000000000000000000000000000000000000000000000000000000000000100000001000000100000001100000100110101000001110110001100110110011011000001111101';

      expect(actualBinaryString, expectedBinaryString);
    });
  });
}
