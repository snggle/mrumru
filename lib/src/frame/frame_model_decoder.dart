import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/frame_dto.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class FrameModelDecoder {
  final FrameSettingsModel framesSettingsModel;
  final ValueChanged<FrameModel>? onFrameDecoded;
  final ValueChanged<FrameModel>? onFirstFrameDecoded;
  final ValueChanged<FrameModel>? onLastFrameDecoded;

  final List<FrameModel> _decodedFrames = <FrameModel>[];
  final StringBuffer _completeBinary = StringBuffer();
  int _cursor = 0;

  FrameModelDecoder({
    required this.framesSettingsModel,
    this.onFrameDecoded,
    this.onFirstFrameDecoded,
    this.onLastFrameDecoded,
  });

  void addBinaries(List<String> binaries) {
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    _decodeFrames();
  }

  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(List<FrameModel>.from(_decodedFrames));
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
  }

  void _decodeFrames() {
    while (_completeBinary.length - _cursor >= framesSettingsModel.frameSize) {
      String frameBinary = _completeBinary.toString().substring(
          _cursor, _cursor + framesSettingsModel.frameSize);
      try {
        List<int> frameBytes = BinaryUtils.binaryStringToByteList(frameBinary);
        bool isFirstFrame = _decodedFrames.isEmpty;
        FrameModel frameModel =
        FrameDto.fromBytes(frameBytes, isFirstFrame: isFirstFrame);

        _decodedFrames.add(frameModel);

        if (isFirstFrame) {
          onFirstFrameDecoded?.call(frameModel);
        }

        if (frameModel.frameIndex == frameModel.framesCount - 1) {
          onLastFrameDecoded?.call(frameModel);
        }

        onFrameDecoded?.call(frameModel);
      } catch (e) {
        AppLogger().log(
          message: 'FrameModelDecoder: Frame decoding failed. Error: $e',
          logLevel: LogLevel.error,
        );
      } finally {
        _cursor += framesSettingsModel.frameSize;
      }
    }
  }
}
