import 'dart:typed_data';
import 'package:mrumru/src/shared/dtos/a_base_frame.dart';
import 'package:mrumru/src/shared/dtos/data_frame.dart';
import 'package:mrumru/src/shared/dtos/frame_protocol_id.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a metadata frame.
class MetadataFrame extends ABaseFrame {
  /// The index of this frame.
  final Uint16 _frameIndex;

  /// The length of this frame's data.
  final Uint16 _frameLength;

  /// The total number of frames in the session.
  final Uint16 _framesCount;

  /// The protocol ID associated with this frame.
  final FrameProtocolID _frameProtocolID;

  /// The session ID of the frame collection.
  final Uint32 _sessionId;

  /// The composite checksum calculated from all frames.
  final Uint32 _compositeChecksum;

  /// The actual data contained within the frame.
  final UintDynamic _data;

  /// The checksum of this frame.
  final Uint16 _frameChecksum;

  /// Creates an instance of [MetadataFrame] with the provided values.
  MetadataFrame({
    required Uint16 frameIndex,
    required Uint16 frameLength,
    required Uint16 framesCount,
    required FrameProtocolID frameProtocolID,
    required Uint32 sessionId,
    required Uint32 compositeChecksum,
    required UintDynamic data,
    required Uint16 frameChecksum,
  })  : _frameIndex = frameIndex,
        _frameLength = frameLength,
        _framesCount = framesCount,
        _frameProtocolID = frameProtocolID,
        _sessionId = sessionId,
        _compositeChecksum = compositeChecksum,
        _data = data,
        _frameChecksum = frameChecksum;

  /// Creates a [MetadataFrame] from the given set of values.
  factory MetadataFrame.fromValues({
    required int frameIndex,
    required FrameProtocolID frameProtocolID,
    required Uint8List sessionId,
    required Uint8List data,
    required List<DataFrame> dataFrames,
  }) {
    Uint16 uint16FrameIndex = Uint16.fromInt(frameIndex);
    Uint16 uint16FrameLength = Uint16.fromInt(data.length);
    Uint16 uint16FramesCount = Uint16.fromInt(dataFrames.length);
    Uint32 uint32SessionId = Uint32(sessionId);
    UintDynamic uintDynamicData = UintDynamic(data, data.length * BinaryUtils.bitsInByte);

    Uint8List compositeChecksumData = Uint8List.fromList(<int>[
      for (DataFrame dataFrame in dataFrames) ...dataFrame.frameChecksum.bytes,
    ]);
    Uint8List compositeChecksumFull = CryptoUtils.calcChecksum(bytes: compositeChecksumData);
    Uint32 uint32CompositeChecksum = Uint32(compositeChecksumFull.sublist(0, 4));

    Uint8List checksumData = Uint8List.fromList(<int>[
      ...uint16FrameIndex.bytes,
      ...uint16FrameLength.bytes,
      ...uint16FramesCount.bytes,
      ...frameProtocolID.bytes,
      ...uint32SessionId.bytes,
      ...uint32CompositeChecksum.bytes,
      ...uintDynamicData.bytes,
    ]);
    Uint8List checksumFull = CryptoUtils.calcChecksum(bytes: checksumData);
    Uint16 uint16FrameChecksum = Uint16(checksumFull.sublist(0, 2));

    return MetadataFrame(
      frameIndex: uint16FrameIndex,
      frameLength: uint16FrameLength,
      framesCount: uint16FramesCount,
      frameProtocolID: frameProtocolID,
      sessionId: uint32SessionId,
      compositeChecksum: uint32CompositeChecksum,
      data: uintDynamicData,
      frameChecksum: uint16FrameChecksum,
    );
  }

  /// Deserializes a [MetadataFrame] from a byte array.
  static FrameReminder<MetadataFrame> fromBytes(Uint8List bytes) {
    UintReminder<Uint16> frameIndex = Uint16.fromBytes(bytes);
    UintReminder<Uint16> frameLength = Uint16.fromBytes(frameIndex.reminder);
    UintReminder<Uint16> framesCount = Uint16.fromBytes(frameLength.reminder);
    UintReminder<FrameProtocolID> frameProtocolID = FrameProtocolID.fromBytes(framesCount.reminder);
    UintReminder<Uint32> sessionId = Uint32.fromBytes(frameProtocolID.reminder);
    UintReminder<Uint32> compositeChecksum = Uint32.fromBytes(sessionId.reminder);
    int dataBitsSize = frameLength.value.toInt() * BinaryUtils.bitsInByte;
    UintReminder<UintDynamic> data = UintDynamic.fromBytes(compositeChecksum.reminder, dataBitsSize);
    UintReminder<Uint16> frameChecksum = Uint16.fromBytes(data.reminder);

    return FrameReminder<MetadataFrame>(
      value: MetadataFrame(
        frameIndex: frameIndex.value,
        frameLength: frameLength.value,
        framesCount: framesCount.value,
        frameProtocolID: frameProtocolID.value,
        sessionId: sessionId.value,
        compositeChecksum: compositeChecksum.value,
        data: data.value,
        frameChecksum: frameChecksum.value,
      ),
      reminder: frameChecksum.reminder,
    );
  }

  /// Serializes the [MetadataFrame] to a byte array.
  @override
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      ..._frameIndex.bytes,
      ..._frameLength.bytes,
      ..._framesCount.bytes,
      ..._frameProtocolID.bytes,
      ..._sessionId.bytes,
      ..._compositeChecksum.bytes,
      ..._data.bytes,
      ..._frameChecksum.bytes,
    ]);
  }

  /// Returns the frame index.
  @override
  Uint16 get frameIndex => _frameIndex;

  /// Returns the frame length.
  @override
  Uint16 get frameLength => _frameLength;

  /// Returns the frame checksum.
  @override
  Uint16 get frameChecksum => _frameChecksum;

  /// Returns the total number of frames in the session.
  Uint16 get framesCount => _framesCount;

  /// Returns the protocol ID for the frame.
  FrameProtocolID get frameProtocolID => _frameProtocolID;

  /// Returns the session ID.
  Uint32 get sessionId => _sessionId;

  /// Returns the composite checksum calculated from all frames.
  Uint32 get compositeChecksum => _compositeChecksum;

  /// Returns the actual data contained in the frame.
  UintDynamic get data => _data;

  @override
  List<Object?> get props => <Object?>[
        _frameIndex,
        _frameLength,
        _framesCount,
        _frameProtocolID,
        _sessionId,
        _compositeChecksum,
        _data,
        _frameChecksum,
      ];
}
