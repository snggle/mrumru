import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/frame_compression_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_encoding_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_version_number.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of MetadataFrame.toBytes()', () {
    test('Should [return correct bytes] representation', () {
      // Arrange
      FrameProtocolID actualFrameProtocolID = FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );

      MetadataFrame actualMetadataFrame = MetadataFrame(
        frameIndex: Uint16.fromInt(1),
        frameLength: Uint16.fromInt(4),
        framesCount: Uint16.fromInt(1),
        frameProtocolID: actualFrameProtocolID,
        sessionId: Uint32(Uint8List.fromList(<int>[0, 0, 0, 1])),
        compositeChecksum: Uint32(Uint8List.fromList(<int>[0, 0, 0, 0])),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16.fromInt(0),
      );

      // Act
      Uint8List actualBytes = actualMetadataFrame.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        0, 1, // framesCount
        ...actualFrameProtocolID.bytes, // frameProtocolID
        0, 0, 0, 1, // sessionId
        0, 0, 0, 0, // compositeChecksum
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of MetadataFrame.fromValues()', () {
    test('Should [return MetadataFrame] correctly from given values', () {
      // Arrange
      int actualFrameIndex = 1;
      FrameProtocolID actualFrameProtocolID = FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );
      Uint8List actualSessionId = Uint8List.fromList(<int>[0, 0, 0, 1]);
      Uint8List actualData = Uint8List.fromList(<int>[1, 2, 3, 4]);
      DataFrame actualDataFrame = DataFrame(
        frameIndex: Uint16.fromInt(1),
        frameLength: Uint16.fromInt(4),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16.fromInt(0),
      );
      List<DataFrame> actualDataFrames = <DataFrame>[actualDataFrame];

      // Act
      MetadataFrame actualMetadataFrame = MetadataFrame.fromValues(
        frameIndex: actualFrameIndex,
        frameProtocolID: actualFrameProtocolID,
        sessionId: actualSessionId,
        data: actualData,
        dataFrames: actualDataFrames,
      );

      // Assert
      FrameReminder<MetadataFrame> expectedMetadataFrame = MetadataFrame.fromBytes(Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        0, 1, // framesCount
        ...actualFrameProtocolID.bytes, // frameProtocolID
        0, 0, 0, 1, // sessionId
        196, 16, 63, 18, // compositeChecksum
        1, 2, 3, 4, // data
        131, 109, // frameChecksum
      ]));

      expect(actualMetadataFrame, expectedMetadataFrame.value);
    });
  });

  group('Test of MetadataFrame.fromBytes()', () {
    test('Should [return MetadataFrame] correctly from given bytes', () {
      // Arrange
      FrameProtocolID actualFrameProtocolID = FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        0, 1, // framesCount
        ...actualFrameProtocolID.bytes, // frameProtocolID
        0, 0, 0, 1, // sessionId
        0, 0, 0, 0, // compositeChecksum
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]);

      // Act
      FrameReminder<MetadataFrame> actualMetadataFrame = MetadataFrame.fromBytes(actualBytes);

      // Assert
      MetadataFrame expectedMetadataFrame = MetadataFrame(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 4])),
        framesCount: Uint16(Uint8List.fromList(<int>[0, 1])),
        frameProtocolID: actualFrameProtocolID,
        sessionId: Uint32(Uint8List.fromList(<int>[0, 0, 0, 1])),
        compositeChecksum: Uint32(Uint8List.fromList(<int>[0, 0, 0, 0])),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16(Uint8List.fromList(<int>[0, 0])),
      );

      expect(actualMetadataFrame.value, expectedMetadataFrame);
    });
  });
}
