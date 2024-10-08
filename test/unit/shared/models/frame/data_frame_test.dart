import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of DataFrame.toBytes()', () {
    test('Should return correct bytes representation', () {
      // Arrange
      DataFrame actualDataFrame = DataFrame(
        frameIndex: Uint16.fromInt(1),
        frameLength: Uint16.fromInt(4),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16.fromInt(0),
      );

      // Act
      Uint8List actualBytes = actualDataFrame.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        ...actualDataFrame.frameIndex.bytes,
        ...actualDataFrame.frameLength.bytes,
        ...actualDataFrame.data.bytes,
        ...actualDataFrame.frameChecksum.bytes,
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of DataFrame.fromValues()', () {
    test('Should construct DataFrame correctly from given values', () {
      // Arrange
      int actualFrameIndex = 1;
      Uint8List actualData = Uint8List.fromList(<int>[1, 2, 3, 4]);

      // Act
      DataFrame actualDataFrame = DataFrame.fromValues(
        frameIndex: actualFrameIndex,
        data: actualData,
      );

      // Assert
      Uint16 expectedFrameIndex = Uint16.fromInt(actualFrameIndex);
      Uint16 expectedFrameLength = Uint16.fromInt(actualData.length);
      UintDynamic expectedData = UintDynamic(actualData, actualData.length * 8);

      Uint8List checksumData = Uint8List.fromList(<int>[
        ...expectedFrameIndex.bytes,
        ...expectedFrameLength.bytes,
        ...expectedData.bytes,
      ]);
      Uint8List checksumFull = CryptoUtils.calcChecksumFromBytes(bytes: checksumData);
      Uint16 expectedFrameChecksum = Uint16(checksumFull.sublist(0, 2));

      DataFrame expectedDataFrame = DataFrame(
        frameIndex: expectedFrameIndex,
        frameLength: expectedFrameLength,
        data: expectedData,
        frameChecksum: expectedFrameChecksum,
      );

      expect(actualDataFrame, expectedDataFrame);
    });
  });

  group('Test of DataFrame.fromBytes()', () {
    test('Should parse DataFrame correctly from given bytes', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]);

      // Act
      FrameReminder<DataFrame> actualDataFrame = DataFrame.fromBytes(actualBytes);

      // Assert
      DataFrame expectedDataFrame = DataFrame(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 4])),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16(Uint8List.fromList(<int>[0, 0])),
      );

      expect(actualDataFrame.value, expectedDataFrame);
    });
  });
}
