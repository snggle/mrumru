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
    AppLogger().log(
      message: 'Adding binaries to decoder: $binaries',
      logLevel: LogLevel.debug,
    );
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    if (_completeBinary.length >= framesSettingsModel.frameSize) {
      _decodeFrames();
    }
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
    String encodedFrames = _completeBinary.toString().substring(_cursor);
    List<String> frameBinaries = BinaryUtils.splitBinary(encodedFrames, framesSettingsModel.frameSize);

    for (String frameBinary in frameBinaries) {
      try {
        List<int> frameBytes = frameBinary.codeUnits;

        FrameModel frameModel = FrameDto.fromBytes(frameBytes, isFirstFrame: _decodedFrames.isEmpty);

        _decodedFrames.add(frameModel);
        if (frameModel.frameIndex == 0) {
          onFirstFrameDecoded?.call(frameModel);
        }
        if (frameModel.frameIndex == frameModel.framesCount - 1) {
          onLastFrameDecoded?.call(frameModel);
        }
        onFrameDecoded?.call(frameModel);

        AppLogger().log(message: 'FrameModelDecoder: Frame decoded: $frameModel. Total: ${frameModel.framesCount}', logLevel: LogLevel.debug);
      } catch (e) {
        AppLogger().log(
          message: 'FrameModelDecoder: Frame decoding failed for $frameBinary. Error: $e',
          logLevel: LogLevel.error,
        );
      } finally {
        _cursor += frameBinary.length;
      }
    }
  }
}
