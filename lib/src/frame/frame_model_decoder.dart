import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/binary_utils.dart';
import 'package:mrumru/src/utils/log_level.dart';

class FrameModelDecoder {
  final FrameSettingsModel framesSettingsModel;
  final ValueChanged<FrameModel>? onFrameDecoded;
  final ValueChanged<FrameModel>? onFirstFrameDecoded;
  final ValueChanged<FrameModel>? onLastFrameDecoded;

  List<FrameModel> decodedFrames = <FrameModel>[];
  StringBuffer completeBinary = StringBuffer();
  int cursor = 0;

  FrameModelDecoder({
    required this.framesSettingsModel,
    this.onFrameDecoded,
    this.onFirstFrameDecoded,
    this.onLastFrameDecoded,
  });

  void addBinaries(List<String> binaries) {
    for (String binary in binaries) {
      completeBinary.write(binary);
    }
    if (completeBinary.length >= framesSettingsModel.frameSize) {
      _decodeFrames();
    }
  }

  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(decodedFrames);
  }

  void _decodeFrames() {
    String encodedFrames = completeBinary.toString().substring(cursor);
    List<String> frameBinaries = BinaryUtils.splitBinary(encodedFrames, framesSettingsModel.frameSize);
    for (String frameBinary in frameBinaries) {
      _decodeFrame(frameBinary);
    }
  }

  void _decodeFrame(String frameBinary) {
    if(frameBinary.length < framesSettingsModel.frameSize) {
      return;
    }
    FrameModel frameModel = FrameModel.fromBinaryString(frameBinary);
    decodedFrames.add(frameModel);
    AppLogger().log(message: 'FrameModelDecoder: Frame decoded: $frameModel. Total: ${frameModel.framesCount}', logLevel: LogLevel.debug);
    cursor += frameModel.binaryString.length;
    if(frameModel.frameIndex == 0) {
      onFirstFrameDecoded?.call(frameModel);
    }
    if(frameModel.frameIndex == frameModel.framesCount - 1) {
      onLastFrameDecoded?.call(frameModel);
    }
    onFrameDecoded?.call(frameModel);
  }
}
