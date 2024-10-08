import 'dart:typed_data';

import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class Uint32FrameProtocolID extends Uint32 {
  final Uint8 frameCompressionType;
  final Uint8 frameEncodingType;
  final Uint8 frameProtocolType;
  final Uint8 frameVersionNumber;

  Uint32FrameProtocolID({
    required this.frameCompressionType,
    required this.frameEncodingType,
    required this.frameProtocolType,
    required this.frameVersionNumber,
  }) : super(
          Uint8List.fromList(<int>[
            ...frameCompressionType.bytes,
            ...frameEncodingType.bytes,
            ...frameProtocolType.bytes,
            ...frameVersionNumber.bytes,
          ]),
        );

  /// Creates FrameProtocolID from Uint8List (4 bytes)
  static UintReminder<Uint32FrameProtocolID> fromBytes(Uint8List bytes) {
    UintReminder<Uint8> frameCompressionType = Uint8.fromBytes(bytes);
    UintReminder<Uint8> frameEncodingType = Uint8.fromBytes(frameCompressionType.reminder);
    UintReminder<Uint8> frameProtocolType = Uint8.fromBytes(frameEncodingType.reminder);
    UintReminder<Uint8> frameVersionNumber = Uint8.fromBytes(frameProtocolType.reminder);

    return UintReminder<Uint32FrameProtocolID>(
      Uint32FrameProtocolID(
        frameCompressionType: frameCompressionType.value,
        frameEncodingType: frameEncodingType.value,
        frameProtocolType: frameProtocolType.value,
        frameVersionNumber: frameVersionNumber.value,
      ),
      frameVersionNumber.reminder,
    );
  }

  factory Uint32FrameProtocolID.fromValues({
    required FrameCompressionType frameCompressionType,
    required FrameEncodingType frameEncodingType,
    required FrameProtocolType frameProtocolType,
    required FrameVersionNumber frameVersionNumber,
  }) {
    return Uint32FrameProtocolID(
      frameCompressionType: Uint8.fromInt(frameCompressionType.value),
      frameEncodingType: Uint8.fromInt(frameEncodingType.value),
      frameProtocolType: Uint8.fromInt(frameProtocolType.value),
      frameVersionNumber: Uint8.fromInt(frameVersionNumber.value),
    );
  }

  @override
  List<Object?> get props => <Object?>[frameCompressionType, frameEncodingType, frameProtocolType, frameVersionNumber];
}
