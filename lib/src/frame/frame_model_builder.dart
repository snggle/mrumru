import 'dart:typed_data';
import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';

class FrameModelBuilder {
  List<ABaseFrame> buildFrames(String rawData) {
    List<ABaseFrame> frames = <ABaseFrame>[];
    List<Uint8List> frameChecksums = <Uint8List>[];
    int maxDataSize = 256;

    List<String> dataChunks = _splitDataIntoChunks(rawData, maxDataSize);
    int framesCount = dataChunks.length;

    String sessionId = Uuid().v4();

    for (int i = 0; i < framesCount; i++) {
      if (i == 0) {
        MetadataFrame frame = _buildMetadataFrame(
          frameIndex: i,
          framesCount: framesCount,
          protocolId: _getProtocolId(),
          sessionId: sessionId,
          data: dataChunks[i],
        );
        frames.add(frame);
        frameChecksums.add(frame.frameChecksum);
      } else {
        DataFrame frame = _buildDataFrame(
          frameIndex: i,
          data: dataChunks[i],
        );
        frames.add(frame);
        frameChecksums.add(frame.frameChecksum);
      }
    }

    Uint8List compositeChecksum = FrameProcessor.computeCompositeChecksum(frameChecksums);

    MetadataFrame firstFrame = frames[0] as MetadataFrame;
    firstFrame = MetadataFrame(
      frameIndex: firstFrame.frameIndex,
      frameLength: firstFrame.frameLength,
      framesCount: firstFrame.framesCount,
      protocolId: firstFrame.protocolId,
      sessionId: firstFrame.sessionId,
      compositeChecksum: compositeChecksum,
      data: firstFrame.data,
      frameChecksum: firstFrame.frameChecksum,
    );

    frames[0] = firstFrame;

    return frames;
  }

  MetadataFrame _buildMetadataFrame({
    required int frameIndex,
    required int framesCount,
    required int protocolId,
    required String sessionId,
    required String data,
  }) {
    int frameLength = MetadataFrame.frameIndexSize +
        MetadataFrame.frameLengthSize +
        MetadataFrame.framesCountSize +
        MetadataFrame.protocolIdSize +
        MetadataFrame.sessionIdSize +
        MetadataFrame.compositeChecksumSize +
        data.codeUnits.length +
        MetadataFrame.frameChecksumSize;

    Uint8List compositeChecksum = Uint8List(MetadataFrame.compositeChecksumSize);

    MetadataFrame frame = MetadataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolId: protocolId,
      sessionId: sessionId,
      compositeChecksum: compositeChecksum,
      data: data,
      frameChecksum: Uint8List(0),
    );

    Uint8List frameBytesWithoutChecksum = frame.toBytes();
    frameBytesWithoutChecksum = frameBytesWithoutChecksum.sublist(
        0, frameBytesWithoutChecksum.length - MetadataFrame.frameChecksumSize);

    Uint8List frameChecksum = FrameProcessor.computeFrameChecksum(frameBytesWithoutChecksum);

    frame = MetadataFrame(
      frameIndex: frame.frameIndex,
      frameLength: frame.frameLength,
      framesCount: frame.framesCount,
      protocolId: frame.protocolId,
      sessionId: frame.sessionId,
      compositeChecksum: frame.compositeChecksum,
      data: frame.data,
      frameChecksum: frameChecksum,
    );

    return frame;
  }

  DataFrame _buildDataFrame({
    required int frameIndex,
    required String data,
  }) {
    int frameLength = DataFrame.frameIndexSize +
        DataFrame.frameLengthSize +
        data.codeUnits.length +
        DataFrame.frameChecksumSize;

    DataFrame frame = DataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      data: data,
      frameChecksum: Uint8List(0),
    );

    Uint8List frameBytesWithoutChecksum = frame.toBytes();
    frameBytesWithoutChecksum = frameBytesWithoutChecksum.sublist(
        0, frameBytesWithoutChecksum.length - DataFrame.frameChecksumSize);

    Uint8List frameChecksum = FrameProcessor.computeFrameChecksum(frameBytesWithoutChecksum);

    frame = DataFrame(
      frameIndex: frame.frameIndex,
      frameLength: frame.frameLength,
      data: frame.data,
      frameChecksum: frameChecksum,
    );

    return frame;
  }

  List<String> _splitDataIntoChunks(String data, int maxChunkSize) {
    List<String> chunks = <String>[];
    for (int i = 0; i < data.length; i += maxChunkSize) {
      int end = (i + maxChunkSize < data.length) ? i + maxChunkSize : data.length;
      chunks.add(data.substring(i, end));
    }
    return chunks;
  }

  int _getProtocolId() {
    return 1;
  }
}
