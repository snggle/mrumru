import 'dart:math';
import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameModelBuilder {
  final FrameSettingsModel frameSettingsModel;
  int _framesCount = 0;
  String _rawData = '';
  int _sessionId = 0;

  FrameModelBuilder({required this.frameSettingsModel});

  FrameCollectionModel buildFrameCollection(String rawData) {
    List<FrameModel> frames = <FrameModel>[];
    _rawData = rawData;
    int asciiPerFrame = frameSettingsModel.asciiCharacterCountInFrame;
    _framesCount = (_rawData.length / asciiPerFrame).ceil();
    _sessionId = _generateSessionId();

    Uint8List compositeChecksum = CryptoUtils.calcChecksum(text: _rawData);

    for (int i = 0; i < _framesCount; i++) {
      FrameModel frame = _generateFrameForIndex(i, compositeChecksum);
      frames.add(frame);
    }

    return FrameCollectionModel(frames);
  }

  FrameModel _generateFrameForIndex(int index, Uint8List compositeChecksum) {
    String frameData = _splitDataForIndex(index);
    int dataLength = frameData.length;
    int controlBytesLength = index == 0
        ? 2 + 2 + 2 + 4 + 4 + 16 + 16
        : 2 + 2 + 16;
    int frameLength = dataLength + controlBytesLength;

    FrameModel frameModel = FrameModel(
      frameIndex: index,
      frameLength: frameLength,
      framesCount: index == 0 ? _framesCount : 0,
      compositeChecksum: index == 0 ? compositeChecksum : Uint8List(16),
      sessionId: index == 0 ? _sessionId : 0,
      rawData: frameData,
      protocolManager: FrameProtocolManager.defaultProtocol(),
    );

    return frameModel;
  }

  String _splitDataForIndex(int index) {
    int startIndex = index * frameSettingsModel.asciiCharacterCountInFrame;
    int endIndex = min(startIndex + frameSettingsModel.asciiCharacterCountInFrame, _rawData.length);
    return _rawData.substring(startIndex, endIndex);
  }

  int _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF;
  }
}
