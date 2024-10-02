import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/protocol/data_frame.dart';
import 'package:mrumru/src/frame/protocol/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/byte_utils.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class FrameModelDecoder {
  final FrameSettingsModel framesSettingsModel;
  final ValueChanged<ABaseFrame>? onFrameDecoded;
  final ValueChanged<ABaseFrame>? onFirstFrameDecoded;
  final ValueChanged<ABaseFrame>? onLastFrameDecoded;

  final List<ABaseFrame> _decodedFrames = <ABaseFrame>[];
  final StringBuffer _completeBinary = StringBuffer();
  int _cursor = 0;
  int? _framesCount; // Store framesCount after decoding the first frame

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
    return FrameCollectionModel(List<ABaseFrame>.from(_decodedFrames));
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
    _framesCount = null;
  }

  void _decodeFrames() {
    while (_cursor < _completeBinary.length) {
      int frameHeaderBitsLength = 32;
      int frameHeaderBytesLength = frameHeaderBitsLength ~/ 8;

      if (_completeBinary.length - _cursor < frameHeaderBitsLength) {
        // Not enough data for frame header
        break;
      }

      // Read frame header
      String headerBinary = _completeBinary.toString().substring(_cursor, _cursor + frameHeaderBitsLength);
      Uint8List headerBytes = BinaryUtils.binaryStringToBytes(headerBinary);

      int frameIndex = ByteUtils.bytesToInt(headerBytes.sublist(0, 2));
      int frameLength = ByteUtils.bytesToInt(headerBytes.sublist(2, 4));

      int frameBitsLength = frameLength * 8;

      if (_completeBinary.length - _cursor < frameBitsLength) {
        // Not enough data for the entire frame
        break;
      }

      // Read the entire frame
      String frameBinary = _completeBinary.toString().substring(_cursor, _cursor + frameBitsLength);
      Uint8List frameBytes = BinaryUtils.binaryStringToBytes(frameBinary);

      try {
        ABaseFrame frame;
        if (_decodedFrames.isEmpty) {
          frame = MetadataFrame.fromBytes(frameBytes);
          _framesCount = (frame as MetadataFrame).framesCount;
          onFirstFrameDecoded?.call(frame);
        } else {
          frame = DataFrame.fromBytes(frameBytes);
        }

        _decodedFrames.add(frame);
        _printFrame(frame);
        if (_framesCount != null && frame.frameIndex == _framesCount! - 1) {
          onLastFrameDecoded?.call(frame);
        }

        onFrameDecoded?.call(frame);
        _cursor += frameBitsLength;
      } catch (e) {
        print('Frame decoding failed: $e');
        break;
      }
    }
  }

  void _printFrame(ABaseFrame frame) {
    print('Decoded frame index: ${frame.frameIndex}');
  }
}
