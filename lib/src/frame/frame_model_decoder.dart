import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';

class FrameModelDecoder {
  final ValueChanged<DataFrame>? onFrameDecoded;
  final ValueChanged<MetadataFrame>? onFirstFrameDecoded;
  final ValueChanged<DataFrame>? onLastFrameDecoded;

  final List<ABaseFrame> _decodedFrames = <ABaseFrame>[];
  final StringBuffer _completeBinary = StringBuffer();

  int _totalDataFrames = 0;
  int _decodedDataFrames = 0;

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
    return FrameCollectionModel(List<ABaseFrame>.from(_decodedFrames));
  }

  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
    _metadataFrameDecodedBool = false;
    _decodedDataFrames = 0;
    _totalDataFrames = 0;
  }

  int _cursor = 0;
  bool _metadataFrameDecodedBool = false;

  void _decodeFrames() {
    if (!_metadataFrameDecodedBool) {
      _decodeMetadataFrame();
    } else {
      _decodeDataFrame();
    }
  }

  void _decodeMetadataFrame() {
    String binaryData = _completeBinary.toString().substring(_cursor);
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(binaryData);

    try {
      FrameReminder<MetadataFrame> metadataFrame = MetadataFrame.fromBytes(bytes);
      _metadataFrameDecodedBool = true;
      _decodedFrames.add(metadataFrame.value);
      onFirstFrameDecoded?.call(metadataFrame.value);

      _totalDataFrames = metadataFrame.value.framesCount.toInt();

      int bitsConsumed = (bytes.length - metadataFrame.reminder.length) * 8;
      _cursor += bitsConsumed;

      _decodeFrames();
    } catch (e) {
      rethrow;
    }
  }

  void _decodeDataFrame() {
    String binaryData = _completeBinary.toString().substring(_cursor);
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(binaryData);

    try {
      FrameReminder<DataFrame> dataFrame = DataFrame.fromBytes(bytes);
      _decodedFrames.add(dataFrame.value);
      _decodedDataFrames++;
      onFrameDecoded?.call(dataFrame.value);

      int bitsConsumed = (bytes.length - dataFrame.reminder.length) * 8;
      _cursor += bitsConsumed;

      if (_decodedDataFrames == _totalDataFrames) {
        onLastFrameDecoded?.call(dataFrame.value);
      } else {
        _decodeFrames();
      }
    } catch (e) {
      rethrow;
    }
  }
}
