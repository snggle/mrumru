import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Tests of FrameModelDecoder process', () {
    late FrameModelDecoder actualFrameModelDecoder;
    late MetadataFrame expectedMetadataFrame;
    late DataFrame expectedDataFrame;
    late List<String> actualFirstChunkedData;
    late List<String> actualSecondChunkedData;

    setUp(() {
      actualFrameModelDecoder = FrameModelDecoder();

      expectedMetadataFrame = _createTestMetadataFrame();

      expectedDataFrame = _createTestDataFrame();

      String metadataBinary = _frameToBinaryString(expectedMetadataFrame);
      String dataBinary = _frameToBinaryString(expectedDataFrame);

      actualFirstChunkedData = _chunkBinaryString(metadataBinary, 4);
      actualSecondChunkedData = _chunkBinaryString(dataBinary, 4);
    });

    test('Should return FrameCollectionModel from given 1st binary data', () {
      // Arrange
      actualFrameModelDecoder.addBinaries(actualFirstChunkedData);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameModelDecoder.decodedContent;

      // Assert
      expect(actualFrameCollectionModel.frames.length, 1);
    });

    test('Should return FrameCollectionModel from given 2nd binary data', () {
      // Arrange
      actualFrameModelDecoder.addBinaries(actualSecondChunkedData);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameModelDecoder.decodedContent;

      // Assert
      expect(actualFrameCollectionModel.frames.length, 0);
    });

    test('Should clear FrameCollectionModel containing frames', () {
      // Arrange
      actualFrameModelDecoder
        ..addBinaries(actualFirstChunkedData)

        // Act
        ..clear();

      // Assert
      expect(actualFrameModelDecoder.decodedContent.frames.isEmpty, true);
    });
  });
}

String _frameToBinaryString(ABaseFrame frame) {
  return frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
}

List<String> _chunkBinaryString(String binaryString, int chunkSize) {
  List<String> chunks = <String>[];
  for (int i = 0; i < binaryString.length; i += chunkSize) {
    int end = (i + chunkSize) > binaryString.length ? binaryString.length : (i + chunkSize);
    chunks.add(binaryString.substring(i, end));
  }
  return chunks;
}

MetadataFrame _createTestMetadataFrame() {
  Uint16 frameIndex = Uint16.fromInt(0);
  Uint16 frameLength = Uint16.fromInt(0);
  Uint16 framesCount = Uint16.fromInt(1);

  Uint32FrameProtocolID frameProtocolID = Uint32FrameProtocolID(
    frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
    frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
    frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
    frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
  );

  Uint32 sessionId = Uint32(Uint8List.fromList(<int>[0, 0, 0, 1]));
  Uint32 compositeChecksum = Uint32(Uint8List.fromList(<int>[0, 0, 0, 0]));
  UintDynamic data = UintDynamic(Uint8List(0), 0);
  Uint16 frameChecksum = Uint16.fromInt(0);

  return MetadataFrame(
    frameIndex: frameIndex,
    frameLength: frameLength,
    framesCount: framesCount,
    frameProtocolID: frameProtocolID,
    sessionId: sessionId,
    compositeChecksum: compositeChecksum,
    data: data,
    frameChecksum: frameChecksum,
  );
}

DataFrame _createTestDataFrame() {
  Uint16 frameIndex = Uint16.fromInt(1);
  Uint8List dataBytes = Uint8List.fromList(<int>[65, 66, 67, 68]);
  Uint16 frameLength = Uint16.fromInt(dataBytes.length);
  UintDynamic data = UintDynamic(dataBytes, dataBytes.length * 8);
  Uint16 frameChecksum = Uint16.fromInt(0);

  return DataFrame(
    frameIndex: frameIndex,
    frameLength: frameLength,
    data: data,
    frameChecksum: frameChecksum,
  );
}
