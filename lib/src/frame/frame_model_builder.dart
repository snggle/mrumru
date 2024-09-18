import 'dart:math';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';

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

    for (int i = 0; i < _framesCount; i++) {
      FrameModel frame = _generateFrameForIndex(i);
      frames.add(frame);
    }

    return FrameCollectionModel(frames);
  }

  FrameModel _generateFrameForIndex(int index) {
    String frameData = _splitDataForIndex(index);
    int dataLength = frameData.length;
    int frameLength = dataLength + (index == 0 ? 20 : 6);
    int compositeChecksum = 0;

    if (index == 0) {
      compositeChecksum = _calculateCompositeChecksum(_rawData);
    }

    FrameModel frameModel = FrameModel(
      frameIndex: index,
      frameLength: frameLength,
      framesCount: index == 0 ? _framesCount : 0,
      compositeChecksum: compositeChecksum,
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
    // Generate a unique session ID (e.g., timestamp or random number)
    return DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF;
  }

  int _calculateCompositeChecksum(String data) {
    // Example checksum calculation: sum of all bytes modulo 65536
    return data.codeUnits.fold(0, (int sum, int byte) => sum + byte) % 65536;
  }
}
