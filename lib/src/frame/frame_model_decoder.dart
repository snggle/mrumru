import 'dart:typed_data';
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

  String _checksumToHex(Uint8List checksum) {
    return checksum.map((int byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  // TODO(arek): Remove this before next full CR
  void _printFrameModel(FrameModel frameModel, bool isFirstFrameBool) {
    print('Decoded FrameModel:');
    print('Frame Index: ${frameModel.frameIndex}');
    print('Frame Length: ${frameModel.frameLength}');
    if (isFirstFrameBool) {
      print('Frames Count: ${frameModel.framesCount}');
      print('Protocol Manager: ${frameModel.protocolManager}');
      print('Session ID: ${frameModel.sessionId}');
      print('Composite Checksum: ${_checksumToHex(frameModel.compositeChecksum)}');
    }
    print('Raw Data: ${frameModel.rawData}');
    print('Frame Checksum: ${_checksumToHex(frameModel.frameChecksum)}');
    print('-----------------------------');
  }

  void _decodeFrames() {
    while (_cursor < _completeBinary.length) {
      if (_completeBinary.length - _cursor < 32) {
        break;
      }
      String headerBinary = _completeBinary.toString().substring(_cursor, _cursor + 32);
      List<int> headerBytes = BinaryUtils.binaryStringToByteList(headerBinary);
      ByteData headerData = ByteData.sublistView(Uint8List.fromList(headerBytes));

      int frameLength = headerData.getUint16(2);

      int frameSizeInBytes = frameLength;
      int frameSizeInBits = frameSizeInBytes * 8;

      if (_completeBinary.length - _cursor < frameSizeInBits) {
        break;
      }

      String frameBinary = _completeBinary.toString().substring(_cursor, _cursor + frameSizeInBits);
      try {
        List<int> frameBytes = BinaryUtils.binaryStringToByteList(frameBinary);
        bool isFirstFrameBool = _decodedFrames.isEmpty;

        FrameModel frameModel = FrameDto.fromBytes(frameBytes, isFirstFrameBool: isFirstFrameBool);
        _decodedFrames.add(frameModel);

        _printFrameModel(frameModel, isFirstFrameBool);

        if (isFirstFrameBool) {
          onFirstFrameDecoded?.call(frameModel);
        }

        if (frameModel.frameIndex == frameModel.framesCount - 1) {
          onLastFrameDecoded?.call(frameModel);
        }

        onFrameDecoded?.call(frameModel);

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
