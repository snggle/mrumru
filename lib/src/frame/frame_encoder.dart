import 'dart:math';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/enums/compression_method.dart';
import 'package:mrumru/src/shared/enums/encoding_method.dart';
import 'package:mrumru/src/shared/enums/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

/// A class responsible for encoding binary data into frames.
class FrameEncoder {
  /// The maximum number of bytes allowed in each frame's data section.
  final int frameDataBytesLength;

  /// Creates a new [FrameEncoder] with a specific frame data length.
  FrameEncoder({required this.frameDataBytesLength});

  /// Builds a frame collection from binary data.
  FrameCollectionModel buildFrameCollection(Uint8List dataBytes) {
    List<DataFrame> dataFrames = <DataFrame>[];
    int dataFramesCount = (dataBytes.length / frameDataBytesLength).ceil();

    for (int i = 0; i < dataFramesCount; i++) {
      Uint8List data = _splitDataForIndex(dataBytes, i);
      int frameIndex = i + 1;

      dataFrames.add(DataFrame.fromValues(
        frameIndex: frameIndex,
        data: data,
      ));
    }

    MetadataFrame metadataFrame = MetadataFrame.fromValues(
      frameIndex: 0,
      frameProtocolID: FrameProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.defaultMethod,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      ),
      sessionId: _generateSessionId(),
      data: Uint8List(0),
      dataFrames: dataFrames,
    );

    return FrameCollectionModel(<ABaseFrame>[metadataFrame, ...dataFrames]);
  }

  /// Splits the binary data into chunks for each frame.
  Uint8List _splitDataForIndex(Uint8List dataBytes, int index) {
    int startIndex = index * frameDataBytesLength;
    int endIndex = min(startIndex + frameDataBytesLength, dataBytes.length);
    return dataBytes.sublist(startIndex, endIndex);
  }

  /// Generates a session ID for the frame collection.
  Uint8List _generateSessionId() {
    return Uint8List.fromList(<int>[1, 2, 3, 4]);
  }
}
