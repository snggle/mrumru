import 'dart:math';
import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/secure_random.dart';

class FrameModelEncoder {
  final int asciiCharacterCountInFrame;

  FrameModelEncoder({required this.asciiCharacterCountInFrame});

  FrameCollectionModel buildFrameCollection(String rawData) {
    List<DataFrame> dataFrames = <DataFrame>[];
    int dataFramesCount = (rawData.length / asciiCharacterCountInFrame).ceil();

    for (int i = 0; i < dataFramesCount; i++) {
      String data = _splitDataForIndex(rawData, i);
      int frameIndex = i + 1;

      Uint8List dataBytes = Uint8List.fromList(data.codeUnits);

      dataFrames.add(DataFrame.fromValues(
        frameIndex: frameIndex,
        data: dataBytes,
      ));
    }

    Uint8List combinedData = Uint8List.fromList(
      dataFrames.expand((DataFrame frame) => frame.data.bytes).toList(),
    );

    MetadataFrame metadataFrame = MetadataFrame.fromValues(
      frameIndex: 0,
      frameProtocolID: Uint32FrameProtocolID.fromValues(
        frameCompressionType: FrameCompressionType.noCompression,
        frameEncodingType: FrameEncodingType.defaultMethod,
        frameProtocolType: FrameProtocolType.rawDataTransfer,
        frameVersionNumber: FrameVersionNumber.firstDefault,
      ),
      sessionId: _generateSessionId(),
      data: combinedData,
      dataFrames: dataFrames,
    );

    return FrameCollectionModel(<ABaseFrame>[metadataFrame, ...dataFrames]);
  }

  String _splitDataForIndex(String rawData, int index) {
    int startIndex = index * asciiCharacterCountInFrame;
    int endIndex = min(startIndex + asciiCharacterCountInFrame, rawData.length);
    return rawData.substring(startIndex, endIndex);
  }

  Uint8List _generateSessionId() {
    Uint8List randomBytes = SecureRandom.getBytes(length: 4, max: 255);
    return randomBytes;
  }
}
