import 'dart:math';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';
import 'package:mrumru/src/shared/models/frame/frame_dto.dart';

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

    FrameModel frameModel = FrameModel(
      frameIndex: index,
      frameLength: frameSettingsModel.frameSize,
      framesCount: _framesCount,
      protocolManager: FrameProtocolManager.defaultProtocol(),
      compositeChecksum: _calculateCompositeChecksum(frameBinaryData),
      rawData: frameBinaryData,
    );

    List<int> frameBytes = FrameDto.toBytes(frameModel, isFirstFrame: index == 0);


    return frameModel;
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
