import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

/// A class that decodes binary data into frames.
class FrameDecoder {
  /// Called whenever any frame is successfully decoded.
  final ValueChanged<ABaseFrame>? onFrameDecoded;

  /// Called when the first (metadata) frame is decoded.
  final ValueChanged<MetadataFrame>? onFirstFrameDecoded;

  /// Called when the last frame is decoded.
  final ValueChanged<DataFrame>? onLastFrameDecoded;

  /// A list of all successfully decoded frames.
  final List<ABaseFrame> _decodedFrames = <ABaseFrame>[];

  /// The complete binary data as a string in StringBuffer.
  final StringBuffer _completeBinary = StringBuffer();

  /// Thi cursor points current position of the decoder within the binary data.
  int _cursor = 0;

  /// The metadata frame that has been decoded used to guide the decoding process.
  MetadataFrame? _metadataFrame;

  /// Creates a [FrameDecoder] with optional callbacks for frame decoding events.
  FrameDecoder({
    this.onFrameDecoded,
    this.onFirstFrameDecoded,
    this.onLastFrameDecoded,
  });

  /// This method takes a list of binary strings, appends them to the existing
  /// binary data buffer, and then attempts to decode frames.
  void addBinaries(List<String> binaries) {
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    _decodeFrames();
  }

  /// Returns the decoded frames as a [FrameCollectionModel].
  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(List<ABaseFrame>.from(_decodedFrames));
  }

  /// This method clears both the decoded frames and the binary data buffer,
  /// resetting the cursor and metadata frame to their initial state.
  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
    _metadataFrame = null;
  }

  /// Depending on the current state, this either decodes the metadata frame or
  /// the subsequent data frames.
  void _decodeFrames() {
    if (_isMetadataFrameDecoded == false) {
      _decodeMetadataFrame();
    } else {
      _decodeDataFrame();
    }
  }

  /// Returns `true` if the metadata frame is already decoded, otherwise `false`.
  bool get _isMetadataFrameDecoded => _metadataFrame != null;

  /// Decodes metadata frame, which is crucial for guiding the decoding of subsequent frames.
  /// If the data is incomplete, decoding is deferred until more data is added.
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
      AppLogger().log(message: 'Error while decoding metadata frame: $e', logLevel: LogLevel.error);
      rethrow;
    }
  }

  /// Each data frame is decoded in sequence after the metadata frame. The process
  /// continues until all frames have been decoded or more data is needed.
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

  /// This getter returns the remaining binary data that has not yet been decoded.
  String get _nextBinaryData => _completeBinary.toString().substring(_cursor);
}
