import 'dart:math';
import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/secure_random.dart';

class FrameModelBuilder {
  final int asciiCharacterCountInFrame;

  FrameModelBuilder({required this.asciiCharacterCountInFrame});

  FrameCollectionModel buildFrameCollection(String rawData) {
    List<AFrameBase> frames = <AFrameBase>[];
    int dataFramesCount = (rawData.length / asciiCharacterCountInFrame).ceil();
    int sessionId = _generateSessionId();

    for (int i = 0; i < dataFramesCount; i++) {
      String data = _splitDataForIndex(rawData, i);
      int frameIndex = i + 1;
      int frameLength = DataFrame.calculateFrameLength(data.length);
      Uint8List frameChecksum = CryptoUtils.calcChecksum(text: data);

      frames.add(DataFrame(
        frameIndex: frameIndex,
        frameLength: frameLength,
        frameChecksum: frameChecksum,
        data: data,
      ));
    }

    int metadataFrameLength = MetadataFrame.calculateFrameLength();
    Uint8List compositeChecksum = Uint8List(MetadataFrame.checksumSize);
    Uint8List metadataFrameChecksum = CryptoUtils.calcChecksumFromBytes(Uint8List(0));

    MetadataFrame metadataFrame = MetadataFrame(
      frameIndex: 0,
      frameLength: metadataFrameLength,
      frameChecksum: metadataFrameChecksum,
      framesCount: dataFramesCount,
      frameProtocolID: FrameProtocolID.defaultProtocol(),
      sessionId: sessionId,
      compositeChecksum: compositeChecksum,
    );

    frames.insert(0, metadataFrame);

    List<int> allFramesBytes = <int>[];
    for (AFrameBase frame in frames) {
      allFramesBytes.addAll(frame.toBytes());
    }

    Uint8List computedCompositeChecksum = CryptoUtils.calcChecksumFromBytes(Uint8List.fromList(allFramesBytes));

    metadataFrame = MetadataFrame(
      frameIndex: metadataFrame.frameIndex,
      frameLength: metadataFrame.frameLength,
      frameChecksum: metadataFrame.frameChecksum,
      framesCount: metadataFrame.framesCount,
      frameProtocolID: metadataFrame.frameProtocolID,
      sessionId: metadataFrame.sessionId,
      compositeChecksum: computedCompositeChecksum,
    );

    frames[0] = metadataFrame;

    return FrameCollectionModel(frames);
  }

  String _splitDataForIndex(String rawData, int index) {
    int startIndex = index * asciiCharacterCountInFrame;
    int endIndex = min(startIndex + asciiCharacterCountInFrame, rawData.length);
    return rawData.substring(startIndex, endIndex);
  }

  int _generateSessionId() {
    Uint8List randomBytes = SecureRandom.getBytes(length: 4, max: 4);
    ByteData byteData = ByteData.sublistView(randomBytes);
    return byteData.getUint32(0);
  }
}
