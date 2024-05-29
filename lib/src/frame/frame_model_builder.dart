import 'dart:math';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

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
    FrameCollectionModel frameCollectionModel = FrameCollectionModel(frames);
    return frameCollectionModel;
  }

  FrameModel _generateFrameForIndex(int index) {
    String frameBinaryData = _splitBinaryDataForIndex(index);

    return FrameModel(
      frameIndex: index,
      framesCount: _framesCount,
      rawData: frameBinaryData,
      frameSettings: frameSettingsModel,
    );
  }

  String _splitBinaryDataForIndex(int index) {
    int startIndex = index * frameSettingsModel.asciiCharacterCountInFrame;
    int endIndex = min(startIndex + frameSettingsModel.asciiCharacterCountInFrame, _rawData.length);
    return _rawData.substring(startIndex, endIndex);
  }
}
