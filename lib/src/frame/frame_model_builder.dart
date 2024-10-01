import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/frame/protocol/data_frame.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_id.dart';
import 'package:mrumru/src/frame/protocol/metadata_frame.dart';

class FrameModelBuilder {
  FrameCollectionModel buildFrameCollection(String rawData) {
    final List<ABaseFrame> frames = <ABaseFrame>[];
    final List<Uint8List> frameChecksums = <Uint8List>[];
    const int maxDataSize = 256;

    final List<String> dataChunks = _splitDataIntoChunks(rawData, maxDataSize);
    final int framesCount = dataChunks.length;

    final String sessionId = _generateSessionId();

    // Build frames and collect their checksums
    for (int i = 0; i < framesCount; i++) {
      if (i == 0) {
        final MetadataFrame metadataFrame = _buildMetadataFrame(
          dataString: dataChunks[i],
          frameIndex: i,
          framesCount: framesCount,
          protocolID: FrameProtocolID.defaultProtocol(),
          sessionId: sessionId,
        );
        frames.add(metadataFrame);
        frameChecksums.add(metadataFrame.frameChecksum);
      } else {
        final DataFrame dataFrame = _buildDataFrame(
          dataString: dataChunks[i],
          frameIndex: i,
        );
        frames.add(dataFrame);
        frameChecksums.add(dataFrame.frameChecksum);
      }
    }
    MetadataFrame firstFrame = frames.first as MetadataFrame;

    Uint8List compositeChecksum = FrameProcessor.computeCompositeChecksum(frameChecksums);
    firstFrame
      ..updateCompositeChecksum(compositeChecksum)
      ..computeChecksums();

    frameChecksums[0] = firstFrame.frameChecksum;

    return FrameCollectionModel(frames);
  }

  List<String> _splitDataIntoChunks(String data, int chunkSize) {
    final List<String> chunks = <String>[];
    for (int i = 0; i < data.length; i += chunkSize) {
      final int end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
      chunks.add(data.substring(i, end));
    }
    return chunks;
  }

  String _generateSessionId() {
    Uint8List randomBytes = Uint8List(16);
    return base64Url.encode(randomBytes);
  }

  MetadataFrame _buildMetadataFrame({
    required String dataString,
    required int frameIndex,
    required int framesCount,
    required FrameProtocolID protocolID,
    required String sessionId,
  }) {
    int frameLength = _calculateFrameLength(dataString, isMetadataFrame: true);
    MetadataFrame metadataFrame = MetadataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolID: protocolID,
      sessionId: sessionId,
      compositeChecksum: Uint8List(16),
      dataString: dataString,
      frameChecksum: Uint8List(16),
    )..computeChecksums();
    return metadataFrame;
  }

  DataFrame _buildDataFrame({
    required String dataString,
    required int frameIndex,
  }) {
    final int frameLength = _calculateFrameLength(dataString, isMetadataFrame: false);
    final DataFrame dataFrame = DataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      dataString: dataString,
      frameChecksum: Uint8List(16),
    )..computeChecksum();
    return dataFrame;
  }

  int _calculateFrameLength(String dataString, {required bool isMetadataFrame}) {
    int length = 2 + 2 + dataString.length + 16;
    if (isMetadataFrame) {
      length += 2 + 4 + 16 + 16;
    }
    return length;
  }
}
