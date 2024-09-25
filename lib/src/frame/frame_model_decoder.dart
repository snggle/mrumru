import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class FrameModelDecoder {
  final FrameSettingsModel framesSettingsModel;
  final ValueChanged<ABaseFrame>? onFrameDecoded;
  final ValueChanged<ABaseFrame>? onFirstFrameDecoded;
  final ValueChanged<ABaseFrame>? onLastFrameDecoded;

  final List<ABaseFrame> _decodedFrames = <ABaseFrame>[];
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
    return FrameCollectionModel(_decodedFrames);
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
  }


  void _printFrame(ABaseFrame frame) {
    print('Decoded Frame:');
    print('Frame Index: ${frame.frameIndexInt}');
    print('Frame Length: ${frame.frameLengthInt}');
    if (frame is MetadataFrame) {
      print('Frames Count: ${frame.framesCountInt}');
      print('Protocol ID: ${frame.protocolIdInt}');
      print('Session ID: ${frame.sessionIdString}');
      print('Composite Checksum: ${frame.compositeChecksumString}');
    }
    if (frame is DataFrame || frame is MetadataFrame) {
      print('Data: ${frame.frameIndexInt}');
    }
    print('Frame Checksum: ${frame.binaryString}');
    print('-----------------------------');
  }

  void _decodeFrames() {
    while (_cursor < _completeBinary.length) {
      int frameHeaderSize = (framesSettingsModel.frameIndexBitsLengthInt +
          framesSettingsModel.frameLengthBitsLengthInt) ~/
          8;
      if (_completeBinary.length - _cursor < frameHeaderSize * 8) {
        break;
      }

      String headerBinary = _completeBinary.toString().substring(_cursor, _cursor + frameHeaderSize * 8);
      List<int> headerBytes = BinaryUtils.binaryStringToByteList(headerBinary);
      ByteData headerData = ByteData.sublistView(Uint8List.fromList(headerBytes));

      int frameIndex = headerData.getUint16(0);
      int frameLength = headerData.getUint16(2);

      int frameSizeInBits = frameLength * 8;

      if (_completeBinary.length - _cursor < frameSizeInBits) {
        break;
      }

      String frameBinary = _completeBinary.toString().substring(_cursor, _cursor + frameSizeInBits);
      List<int> frameBytes = BinaryUtils.binaryStringToByteList(frameBinary);

      try {
        bool isFirstFrame = _decodedFrames.isEmpty;

        ABaseFrame frame;
        if (isFirstFrame) {
          frame = MetadataFrame.fromBytes(Uint8List.fromList(frameBytes), framesSettingsModel);
          onFirstFrameDecoded?.call(frame);
        } else {
          frame = DataFrame.fromBytes(Uint8List.fromList(frameBytes), framesSettingsModel);
        }

        _decodedFrames.add(frame);

        _printFrame(frame);

        if (frame is MetadataFrame && frame.frameIndexInt == frame.framesCountInt - 1) {
          onLastFrameDecoded?.call(frame);
        }

        onFrameDecoded?.call(frame);

        _cursor += frameSizeInBits;
      } catch (e) {
        AppLogger().log(
          message: 'FrameModelDecoder: Frame decoding failed. Error: $e',
          logLevel: LogLevel.error,
        );
        break;
      }
    }
  }
}
