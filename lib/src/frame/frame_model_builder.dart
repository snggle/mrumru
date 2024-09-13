import 'dart:math';
import 'package:mrumru/mrumru.dart';

class FrameModelBuilder {
  final FrameSettingsModel frameSettingsModel;

  late int _framesCount;
  late String _rawData;

  FrameModelBuilder({required this.frameSettingsModel});

  FrameCollectionModel buildFrameCollection(String rawData) {
    List<FrameModel> frames = <FrameModel>[];
    _rawData = rawData;
    _framesCount = (_rawData.length / frameSettingsModel.asciiCharacterCountInFrame).ceil();

    for (int i = 0; i < _framesCount; i++) {
      FrameModel frame = _generateFrameForIndex(i);
      frames.add(frame);
    }
    return FrameCollectionModel(frames);
  }

  FrameModel _generateFrameForIndex(int index) {
    String frameBinaryData = _splitBinaryDataForIndex(index);

    return FrameModel(
      frameIndex: index,
      frameLength: frameSettingsModel.frameSize,
      framesCount: _framesCount,
      protocolId: 0,
      sessionId: 12345,
      compressionMethod: 0,
      encodingMethod: 1,
      protocolType: 0,
      versionNumber: 1,
      compositeChecksum: _calculateCompositeChecksum(frameBinaryData),
      rawData: frameBinaryData,
    );
  }

  String _splitBinaryDataForIndex(int index) {
    int startIndex = index * frameSettingsModel.asciiCharacterCountInFrame;
    int endIndex = min(startIndex + frameSettingsModel.asciiCharacterCountInFrame, _rawData.length);
    return _rawData.substring(startIndex, endIndex);
  }

  int _calculateCompositeChecksum(String data) {
    return data.codeUnits.fold(0, (int sum, int byte) => sum + byte) % 65536;
  }
}
