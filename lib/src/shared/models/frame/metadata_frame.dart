import 'dart:typed_data';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class MetadataFrame extends ABaseFrame {
  final Uint16 _frameIndex;
  final Uint16 _frameLength;
  final Uint16 _framesCount;
  final Uint32FrameProtocolID _frameProtocolID;
  final Uint32 _sessionId;
  final Uint32 _compositeChecksum;
  final UintDynamic _data;
  final Uint16 _frameChecksum;

  MetadataFrame({
    required Uint16 frameIndex,
    required Uint16 frameLength,
    required Uint16 framesCount,
    required Uint32FrameProtocolID frameProtocolID,
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

  factory MetadataFrame.fromValues({
    required int frameIndex,
    required Uint32FrameProtocolID frameProtocolID,
    required Uint8List sessionId,
    required Uint8List data,
    required List<DataFrame> dataFrames,
  }) {
    Uint16 uint16frameIndex = Uint16.fromInt(frameIndex);
    Uint16 uint16frameLength = Uint16.fromInt(data.length);
    Uint16 uint16framesCount = Uint16.fromInt(dataFrames.length);
    Uint32 uint32sessionId = Uint32(sessionId);
    UintDynamic uintDynamicData = UintDynamic(data, data.length * 8);

    Uint8List compositeChecksumData = Uint8List.fromList(<int>[
      for (DataFrame dataFrame in dataFrames) ...dataFrame.frameChecksum.bytes,
    ]);
    Uint8List compositeChecksumFull = CryptoUtils.calcChecksumFromBytes( bytes: compositeChecksumData);
    Uint32 uint32compositeChecksum = Uint32(compositeChecksumFull.sublist(0, 4));

    Uint8List checksumData = Uint8List.fromList(<int>[
      ...uint16frameIndex.bytes,
      ...uint16frameLength.bytes,
      ...uint16framesCount.bytes,
      ...frameProtocolID.bytes,
      ...uint32sessionId.bytes,
      ...uint32compositeChecksum.bytes,
      ...uintDynamicData.bytes,
    ]);
    Uint8List checksumFull = CryptoUtils.calcChecksumFromBytes(bytes: checksumData);
    Uint16 uint16frameChecksum = Uint16(checksumFull.sublist(0, 2));

    return MetadataFrame(
      frameIndex: uint16frameIndex,
      frameLength: uint16frameLength,
      framesCount: uint16framesCount,
      frameProtocolID: frameProtocolID,
      sessionId: uint32sessionId,
      compositeChecksum: uint32compositeChecksum,
      data: uintDynamicData,
      frameChecksum: uint16frameChecksum,
    );
  }

  static FrameReminder<MetadataFrame> fromBytes(Uint8List bytes) {
    UintReminder<Uint16> frameIndex = Uint16.fromBytes(bytes);
    UintReminder<Uint16> frameLength = Uint16.fromBytes(frameIndex.reminder);
    UintReminder<Uint16> framesCount = Uint16.fromBytes(frameLength.reminder);
    UintReminder<Uint32FrameProtocolID> frameProtocolID = Uint32FrameProtocolID.fromBytes(framesCount.reminder);
    UintReminder<Uint32> sessionId = Uint32.fromBytes(frameProtocolID.reminder);
    UintReminder<Uint32> compositeChecksum = Uint32.fromBytes(sessionId.reminder);
    int dataBitsSize = frameLength.value.toInt() * 8;
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

  @override
  Uint16 get frameIndex => _frameIndex;

  @override
  Uint16 get frameLength => _frameLength;

  Uint16 get framesCount => _framesCount;

  Uint32FrameProtocolID get frameProtocolID => _frameProtocolID;

  Uint32 get sessionId => _sessionId;

  Uint32 get compositeChecksum => _compositeChecksum;

  UintDynamic get data => _data;

  @override
  Uint16 get frameChecksum => _frameChecksum;

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
