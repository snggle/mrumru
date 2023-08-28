import 'dart:math';

import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/models/frame_settings_model.dart';
import 'package:mrumru/src/utils/app_logger.dart';

class FrameModelDecoder {
  final FrameSettingsModel framesSettingsModel;

  FrameModelDecoder({required this.framesSettingsModel});

  FrameCollectionModel decodeBinaryData(String binaryData) {
    List<FrameModel> frameModels = <FrameModel>[];

    for (int i = 0; i < binaryData.length; i += framesSettingsModel.frameSize) {
      int frameIndex = i ~/ framesSettingsModel.frameSize;
      try {
        String frameBinary = binaryData.substring(i, min(i + framesSettingsModel.frameSize, binaryData.length));
        FrameModel frameModel = FrameModel.fromBinaryString(frameBinary);
        frameModels.add(frameModel);
        AppLogger().log(message: 'Decoded frame at index $frameIndex ($frameModel)');
      } catch (_) {
        AppLogger().log(message: 'Cannot decode frame at index $frameIndex');
      }
    }
    FrameCollectionModel frameCollectionModel = FrameCollectionModel(frameModels);
    return frameCollectionModel;
  }
}
