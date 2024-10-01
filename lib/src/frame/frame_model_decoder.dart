import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class FrameModelDecoder {
  final ValueChanged<DataFrame>? onFrameDecoded;
  final ValueChanged<MetadataFrame>? onFirstFrameDecoded;
  final ValueChanged<DataFrame>? onLastFrameDecoded;

  final List<AFrameBase> _decodedFrames = <AFrameBase>[];
  final StringBuffer _completeBinary = StringBuffer();
  int _frameCount = 0;
  int _cursor = 0;

  FrameModelDecoder({
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
    return FrameCollectionModel(List<AFrameBase>.from(_decodedFrames));
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
  }

  void _decodeFrames() {
    int headerBitsLength =
        (MetadataFrame.frameIndexSize + MetadataFrame.frameLengthSize) * 8;

    while (_hasEnoughDataForHeader(headerBitsLength)) {
      try {
        int initialCursor = _cursor;

        ByteData headerData = _readHeader(headerBitsLength);

        int frameIndex = headerData.getUint16(0, Endian.big);
        int frameLength =
        headerData.getUint16(MetadataFrame.frameIndexSize, Endian.big);

        int frameSizeInBits = frameLength * 8;

        if (!_hasEnoughDataForFrame(initialCursor, frameSizeInBits)) {
          break;
        }

        Uint8List frameBytes = _readFrameBytes(initialCursor, frameSizeInBits);

        AFrameBase frame = _decodeFrame(frameIndex, frameBytes);

        _verifyFrameChecksum(frame);

        _decodedFrames.add(frame);

        _cursor = initialCursor + frameSizeInBits;
      } catch (e) {
        AppLogger().log(
          message: 'FrameModelDecoder: Frame decoding failed. Error: $e',
          logLevel: LogLevel.error,
        );
        break;
      }
    }

    if (_decodedFrames.length == _frameCount + 1) {
      _verifyCompositeChecksum();
    }
  }

  bool _hasEnoughDataForHeader(int headerBitsLength) {
    return _cursor + headerBitsLength <= _completeBinary.length;
  }

  ByteData _readHeader(int headerBitsLength) {
    String headerBinary =
    _completeBinary.toString().substring(_cursor, _cursor + headerBitsLength);
    List<int> headerBytes = BinaryUtils.binaryStringToByteList(headerBinary);
    ByteData headerData = ByteData.sublistView(Uint8List.fromList(headerBytes));


    return headerData;
  }

  bool _hasEnoughDataForFrame(int initialCursor, int frameSizeInBits) {
    return initialCursor + frameSizeInBits <= _completeBinary.length;
  }

  Uint8List _readFrameBytes(int initialCursor, int frameSizeInBits) {
    String frameBinary = _completeBinary.toString()
        .substring(initialCursor, initialCursor + frameSizeInBits);
    List<int> frameBytes = BinaryUtils.binaryStringToByteList(frameBinary);


    return Uint8List.fromList(frameBytes);
  }

  AFrameBase _decodeFrame(int frameIndex, Uint8List frameBytes) {
    AFrameBase frame;
    if (_decodedFrames.isEmpty && frameIndex == 0) {
      frame = MetadataFrame.fromBytes(frameBytes);
      _frameCount = (frame as MetadataFrame).framesCount;
      onFirstFrameDecoded?.call(frame as MetadataFrame);
    } else {
      frame = DataFrame.fromBytes(frameBytes);
      onFrameDecoded?.call(frame as DataFrame);

      if (frame.frameIndex == _frameCount) {
        onLastFrameDecoded?.call(frame as DataFrame);
      }
    }
    return frame;
  }

  void _verifyFrameChecksum(AFrameBase frame) {
    Uint8List expectedChecksum;
    if (frame is DataFrame) {
      expectedChecksum = CryptoUtils.calcChecksum(text: frame.data);
    } else {
      expectedChecksum = CryptoUtils.calcChecksumFromBytes(Uint8List(0));
    }

    if (!BinaryUtils.compareUint8Lists(frame.frameChecksum, expectedChecksum)) {
      AppLogger().log(
        message:
        'FrameModelDecoder: Frame checksum mismatch for frameIndex ${frame.frameIndex}',
        logLevel: LogLevel.error,
      );
    }
  }

  void _verifyCompositeChecksum() {
    List<int> allFramesBytes = <int>[];
    for (AFrameBase frame in _decodedFrames) {
      allFramesBytes.addAll(frame.toBytes());
    }

    Uint8List receivedCompositeChecksum =
        (_decodedFrames.first as MetadataFrame).compositeChecksum;
    Uint8List calculatedChecksum =
    CryptoUtils.calcChecksumFromBytes(Uint8List.fromList(allFramesBytes));

    if (BinaryUtils.compareUint8Lists(
        receivedCompositeChecksum, calculatedChecksum)) {
      AppLogger().log(
        message: 'Composite checksum verified successfully.',
        logLevel: LogLevel.info,
      );
    } else {
      AppLogger().log(
        message: 'Composite checksum mismatch!',
        logLevel: LogLevel.error,
      );
    }
  }
}
