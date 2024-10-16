import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of MetadataFrame.toBytes()', () {
    test('Should [return bytes] representation', () {
      // Arrange
      MetadataFrame actualMetadataFrame = MetadataFrame.fromValues(
          frameIndex: 0,
          frameProtocolID: FrameProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[]);

      // Act
      Uint8List actualBytes = actualMetadataFrame.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 0, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // frameProtocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        128, 97, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of MetadataFrame.fromValues()', () {
    test('Should [return MetadataFrame] correctly from given values', () {
      // Act
      MetadataFrame actualMetadataFrame = MetadataFrame.fromValues(
          frameIndex: 0,
          frameProtocolID: FrameProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[]);

      // Assert
      MetadataFrame expectedMetadataFrame = MetadataFrame(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 0])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 0])),
        framesCount: Uint16(Uint8List.fromList(<int>[0, 0])),
        frameProtocolID: FrameProtocolID(
          compressionMethod: Uint8.fromInt(0),
          encodingMethod: Uint8.fromInt(0),
          protocolType: Uint8.fromInt(0),
          versionNumber: Uint8.fromInt(1),
        ),
        sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
        compositeChecksum: Uint32(Uint8List.fromList(<int>[212, 29, 140, 217])),
        data: UintDynamic(Uint8List.fromList(<int>[]), 0),
        frameChecksum: Uint16(Uint8List.fromList(<int>[128, 97])),
      );

      expect(actualMetadataFrame, expectedMetadataFrame);
    });
  });

  group('Test of MetadataFrame.fromBytes()', () {
    test('Should [return FrameReminder] containing MetadataFrame from given bytes when [reminder EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // frameProtocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        176, 125, // frameChecksum
      ]);

      // Act
      FrameReminder<MetadataFrame> actualMetadataFrame = MetadataFrame.fromBytes(actualBytes);

      // Assert
      FrameReminder<MetadataFrame> expectedMetadataFrame = FrameReminder<MetadataFrame>(
        value: MetadataFrame.fromValues(
          frameIndex: 1,
          frameProtocolID: FrameProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[],
        ),
        reminder: Uint8List.fromList(<int>[]),
      );

      expect(actualMetadataFrame, expectedMetadataFrame);
    });

    test('Should [return FrameReminder] containing MetadataFrame from given bytes when [reminder NOT EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // frameProtocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        176, 125, // frameChecksum
        0, 25, // reminder
      ]);

      // Act
      FrameReminder<MetadataFrame> actualMetadataFrame = MetadataFrame.fromBytes(actualBytes);

      // Assert
      FrameReminder<MetadataFrame> expectedMetadataFrame = FrameReminder<MetadataFrame>(
        value: MetadataFrame.fromValues(
          frameIndex: 1,
          frameProtocolID: FrameProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[],
        ),
        reminder: Uint8List.fromList(<int>[0, 25]),
      );

      expect(actualMetadataFrame, expectedMetadataFrame);
    });
  });
}
