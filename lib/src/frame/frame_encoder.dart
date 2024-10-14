import 'dart:math';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/frame_compression_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_encoding_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_version_number.dart';

import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';

/// A class that encodes frames from binary data.
class FrameEncoder {
  /// The length of the data bytes in each frame.
  final int frameDataBytesLength;

  /// Creates a new instance of [FrameEncoder] with the given [frameDataBytesLength].
  FrameEncoder({required this.frameDataBytesLength});

  /// Builds a frame collection from the given [dataBytes].
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
        frameCompressionType: FrameCompressionType.noCompression,
        frameEncodingType: FrameEncodingType.defaultMethod,
        frameProtocolType: FrameProtocolType.rawDataTransfer,
        frameVersionNumber: FrameVersionNumber.firstDefault,
      ),
      sessionId: _generateSessionId(),
      data: Uint8List(0),
      dataFrames: dataFrames,
    );

    return FrameCollectionModel(<ABaseFrame>[metadataFrame, ...dataFrames]);
  }

  /// Splits the given [dataBytes] into chunks of [frameDataBytesLength] bytes.
  Uint8List _splitDataForIndex(Uint8List dataBytes, int index) {
    int startIndex = index * frameDataBytesLength;
    int endIndex = min(startIndex + frameDataBytesLength, dataBytes.length);
    return dataBytes.sublist(startIndex, endIndex);
  }

  /// Generates a session ID for the metadata frame.
  // TODO(arek): Randomize sessionID after half-duplex communication is implemented
  Uint8List _generateSessionId() {
    return Uint8List.fromList(<int>[1, 2, 3, 4]);
  }
}
