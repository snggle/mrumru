import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
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
    AppLogger().log(message: 'Adding binaries to decoder: $binaries', logLevel: LogLevel.debug);
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    if (_completeBinary.length >= framesSettingsModel.frameSize) {
      _decodeFrames();
    }
  }

  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(_decodedFrames);
  }

  void _decodeFrames() {
    final String encodedFrames = _completeBinary.toString().substring(_cursor);
    final List<String> frameBinaries = BinaryUtils.splitBinary(encodedFrames, framesSettingsModel.frameSize);
    for (String frameBinary in frameBinaries) {
      _decodeFrame(frameBinary);
    }
  }

  void _decodeFrame(String frameBinary) {
    if (frameBinary.length < framesSettingsModel.frameSize) {
      return;
    }

    try {
      final FrameModel frameModel = FrameModel.fromBinaryString(frameBinary);
      _decodedFrames.add(frameModel);
      if (frameModel.frameIndex == 0) {
        onFirstFrameDecoded?.call(frameModel);
      }
      if (frameModel.frameIndex == frameModel.framesCount - 1) {
        onLastFrameDecoded?.call(frameModel);
      }
      onFrameDecoded?.call(frameModel);
      AppLogger().log(message: 'FrameModelDecoder: Frame decoded: $frameModel. Total: ${frameModel.framesCount}', logLevel: LogLevel.debug);
    } catch (_) {
      AppLogger().log(message: 'FrameModelDecoder: Frame decoding failed for $frameBinary', logLevel: LogLevel.error);
    } finally {
      _cursor += frameBinary.length;
    }
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
  }
}
