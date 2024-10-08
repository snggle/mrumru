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

  final List<AFrameBase> _decodedFrames = <AFrameBase>[];
  final StringBuffer _completeBinary = StringBuffer();

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
  }

  int cursor = 0;
  bool _metadataFrameDecodedBool = false;

  void _decodeFrames() {
    if (_metadataFrameDecodedBool) {
      _decodeMetadataFrame();
    } else {
      _decodeDataFrame();
    }
  }

  void _decodeMetadataFrame() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_completeBinary.toString().substring(cursor));
    try {
      FrameReminder<MetadataFrame> metadataFrame = MetadataFrame.fromBytes(bytes);
      _metadataFrameDecodedBool = true;
      _decodedFrames.add(metadataFrame.value);
      onFirstFrameDecoded?.call(metadataFrame.value);

      cursor += metadataFrame.reminder.length * 8;
      return;
    } catch (_) {
      return;
    }
  }

  void _decodeDataFrame() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_completeBinary.toString().substring(cursor));

    try {
      FrameReminder<DataFrame> dataFrame = DataFrame.fromBytes(bytes);
      _decodedFrames.add(dataFrame.value);
      onFrameDecoded?.call(dataFrame.value);

      cursor += dataFrame.reminder.length * 8;
    } catch (_) {
      return;
    }
  }
}
