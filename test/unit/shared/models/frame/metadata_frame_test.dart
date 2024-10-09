import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of MetadataFrame.toBytes()', () {
    test('Should return correct bytes representation', () {
      // Arrange
      Uint32FrameProtocolID actualFrameProtocolID = Uint32FrameProtocolID(
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
        ...actualMetadataFrame.frameIndex.bytes,
        ...actualMetadataFrame.frameLength.bytes,
        ...actualMetadataFrame.framesCount.bytes,
        ...actualMetadataFrame.frameProtocolID.bytes,
        ...actualMetadataFrame.sessionId.bytes,
        ...actualMetadataFrame.compositeChecksum.bytes,
        ...actualMetadataFrame.data.bytes,
        ...actualMetadataFrame.frameChecksum.bytes,
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of MetadataFrame.fromValues()', () {
    test('Should construct MetadataFrame correctly from given values', () {
      // Arrange
      int actualFrameIndex = 1;
      Uint32FrameProtocolID actualFrameProtocolID = Uint32FrameProtocolID(
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
      Uint16 expectedFrameIndex = Uint16.fromInt(actualFrameIndex);
      Uint16 expectedFrameLength = Uint16.fromInt(actualData.length);
      Uint16 expectedFramesCount = Uint16.fromInt(actualDataFrames.length);
      Uint32 expectedSessionId = Uint32(actualSessionId);
      UintDynamic expectedData = UintDynamic(actualData, actualData.length * 8);

      Uint8List actualCompositeChecksumData = Uint8List.fromList(<int>[
        for (DataFrame df in actualDataFrames) ...df.frameChecksum.bytes,
      ]);
      Uint8List actualCompositeChecksum = CryptoUtils.calcChecksumFromBytes(bytes: actualCompositeChecksumData);
      Uint32 expectedCompositeChecksum = Uint32(actualCompositeChecksum.sublist(0, 4));

      Uint8List checksumData = Uint8List.fromList(<int>[
        ...expectedFrameIndex.bytes,
        ...expectedFrameLength.bytes,
        ...expectedFramesCount.bytes,
        ...actualFrameProtocolID.bytes,
        ...expectedSessionId.bytes,
        ...expectedCompositeChecksum.bytes,
        ...expectedData.bytes,
      ]);
      Uint8List expectedChecksum = CryptoUtils.calcChecksumFromBytes(bytes: checksumData);
      Uint16 expectedFrameChecksum = Uint16(expectedChecksum.sublist(0, 2));

      MetadataFrame expectedMetadataFrame = MetadataFrame(
        frameIndex: expectedFrameIndex,
        frameLength: expectedFrameLength,
        framesCount: expectedFramesCount,
        frameProtocolID: actualFrameProtocolID,
        sessionId: expectedSessionId,
        compositeChecksum: expectedCompositeChecksum,
        data: expectedData,
        frameChecksum: expectedFrameChecksum,
      );

      expect(actualMetadataFrame, expectedMetadataFrame);
    });
  });

  group('Test of MetadataFrame.fromBytes()', () {
    test('Should parse MetadataFrame correctly from given bytes', () {
      // Arrange
      Uint32FrameProtocolID actualFrameProtocolID = Uint32FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0x00, 0x01, // frameIndex
        0x00, 0x04, // frameLength
        0x00, 0x01, // framesCount
        ...actualFrameProtocolID.bytes, // frameProtocolID
        0x00, 0x00, 0x00, 0x01, // sessionId
        0x00, 0x00, 0x00, 0x00, // compositeChecksum
        0x01, 0x02, 0x03, 0x04, // data
        0x00, 0x00, // frameChecksum
      ]);

      // Act
      FrameReminder<MetadataFrame> actualMetadataFrame = MetadataFrame.fromBytes(actualBytes);

      // Assert
      MetadataFrame expectedMetadataFrame = MetadataFrame(
        frameIndex: Uint16(Uint8List.fromList(<int>[0x00, 0x01])),
        frameLength: Uint16(Uint8List.fromList(<int>[0x00, 0x04])),
        framesCount: Uint16(Uint8List.fromList(<int>[0x00, 0x01])),
        frameProtocolID: actualFrameProtocolID,
        sessionId: Uint32(Uint8List.fromList(<int>[0x00, 0x00, 0x00, 0x01])),
        compositeChecksum: Uint32(Uint8List.fromList(<int>[0x00, 0x00, 0x00, 0x00])),
        data: UintDynamic(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]), 32),
        frameChecksum: Uint16(Uint8List.fromList(<int>[0x00, 0x00])),
      );

      expect(actualMetadataFrame.value, expectedMetadataFrame);
    });
  });
}
