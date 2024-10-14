import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

/// A class that decodes frames from binary data.
class FrameDecoder {
  /// The callbacks that are called when a frame is decoded or when the first or last frame is decoded.
  final ValueChanged<ABaseFrame>? onFrameDecoded;
  final ValueChanged<MetadataFrame>? onFirstFrameDecoded;
  final ValueChanged<DataFrame>? onLastFrameDecoded;

  /// The decoded frames list and the complete binary data.
  final List<ABaseFrame> _decodedFrames = <ABaseFrame>[];
  final StringBuffer _completeBinary = StringBuffer();

  /// The cursor and the metadata frame.
  int _cursor = 0;
  MetadataFrame? _metadataFrame;

  /// Creates a new instance of [FrameDecoder] with the given callbacks.
  FrameDecoder({
    this.onFrameDecoded,
    this.onFirstFrameDecoded,
    this.onLastFrameDecoded,
  });

  /// Adds the given [binaries] to the complete binary data and decodes the frames.
  void addBinaries(List<String> binaries) {
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    _decodeFrames();
  }

  /// The decoded content of the frame collection.
  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(List<ABaseFrame>.from(_decodedFrames));
  }

  /// Clears the decoded frames and the complete binary data.
  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
    _metadataFrame = null;
  }

  /// Decodes the frames from the complete binary data.
  void _decodeFrames() {
    if (_isMetadataFrameDecoded == false) {
      _decodeMetadataFrame();
    } else {
      _decodeDataFrame();
    }
  }

  /// Returns whether the metadata frame is decoded.
  bool get _isMetadataFrameDecoded => _metadataFrame != null;

  /// Decodes the metadata frame from the complete binary data.
  void _decodeMetadataFrame() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_nextBinaryData);

    try {
      FrameReminder<MetadataFrame> decodedMetadataFrame = MetadataFrame.fromBytes(bytes);
      MetadataFrame metadataFrame = decodedMetadataFrame.value;

      _metadataFrame = metadataFrame;
      _decodedFrames.add(metadataFrame);
      _cursor += decodedMetadataFrame.bitsConsumed;

      onFirstFrameDecoded?.call(metadataFrame);
      onFrameDecoded?.call(metadataFrame);

      _decodeFrames();
    } on BytesTooShortException catch (_) {
      return;
    } catch (e) {
      AppLogger().log(message: 'Error while decoding data frame: $e', logLevel: LogLevel.error);
      rethrow;
    }
  }

  /// Decodes the data frame from the complete binary data.
  void _decodeDataFrame() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_nextBinaryData);

    try {
      FrameReminder<DataFrame> decodedDataFrame = DataFrame.fromBytes(bytes);
      DataFrame dataFrame = decodedDataFrame.value;

      _decodedFrames.add(dataFrame);
      _cursor += decodedDataFrame.bitsConsumed;

      bool lastFrameBool = _metadataFrame!.framesCount.toInt() == dataFrame.frameIndex.toInt();
      if (lastFrameBool) {
        onFrameDecoded?.call(dataFrame);
        onLastFrameDecoded?.call(dataFrame);
      } else {
        onFrameDecoded?.call(dataFrame);
        _decodeFrames();
      }
    } on BytesTooShortException catch (_) {
      return;
    } catch (e) {
      AppLogger().log(message: 'Error while decoding data frame: $e', logLevel: LogLevel.error);
      rethrow;
    }
  }

  /// Returns the next binary data.
  String get _nextBinaryData => _completeBinary.toString().substring(_cursor);
}
