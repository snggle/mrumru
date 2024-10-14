import 'dart:typed_data';

import 'package:mrumru/src/shared/models/frame/frame_compression_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_encoding_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_version_number.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a FrameProtocolID.
class FrameProtocolID extends Uint32 {
  /// The value of the [FrameProtocolID].
  final Uint8 frameCompressionType;
  final Uint8 frameEncodingType;
  final Uint8 frameProtocolType;
  final Uint8 frameVersionNumber;

  /// Creates a instance of [FrameProtocolID] with the given values.
  FrameProtocolID({
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

  /// Creates a instance of [FrameProtocolID] from the given [bytes].
  static UintReminder<FrameProtocolID> fromBytes(Uint8List bytes) {
    UintReminder<Uint8> frameCompressionType = Uint8.fromBytes(bytes);
    UintReminder<Uint8> frameEncodingType = Uint8.fromBytes(frameCompressionType.reminder);
    UintReminder<Uint8> frameProtocolType = Uint8.fromBytes(frameEncodingType.reminder);
    UintReminder<Uint8> frameVersionNumber = Uint8.fromBytes(frameProtocolType.reminder);

    return UintReminder<FrameProtocolID>(
      FrameProtocolID(
        frameCompressionType: frameCompressionType.value,
        frameEncodingType: frameEncodingType.value,
        frameProtocolType: frameProtocolType.value,
        frameVersionNumber: frameVersionNumber.value,
      ),
      frameVersionNumber.reminder,
    );
  }

  /// Creates a instance of [FrameProtocolID] from the given [values].
  factory FrameProtocolID.fromValues({
    required FrameCompressionType frameCompressionType,
    required FrameEncodingType frameEncodingType,
    required FrameProtocolType frameProtocolType,
    required FrameVersionNumber frameVersionNumber,
  }) {
    return FrameProtocolID(
      frameCompressionType: Uint8.fromInt(frameCompressionType.value),
      frameEncodingType: Uint8.fromInt(frameEncodingType.value),
      frameProtocolType: Uint8.fromInt(frameProtocolType.value),
      frameVersionNumber: Uint8.fromInt(frameVersionNumber.value),
    );
  }

  @override
  List<Object?> get props => <Object?>[frameCompressionType, frameEncodingType, frameProtocolType, frameVersionNumber];
}
