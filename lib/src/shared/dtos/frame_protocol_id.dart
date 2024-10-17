import 'dart:typed_data';

import 'package:mrumru/src/shared/enums/compression_method.dart';
import 'package:mrumru/src/shared/enums/encoding_method.dart';
import 'package:mrumru/src/shared/enums/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a [FrameProtocolID].
class FrameProtocolID extends Uint32 {
  /// The value of the [FrameProtocolID].
  final Uint8 compressionMethod;
  final Uint8 encodingMethod;
  final Uint8 protocolType;
  final Uint8 versionNumber;

  /// Creates a instance of [FrameProtocolID] with the given values.
  FrameProtocolID({
    required this.compressionMethod,
    required this.encodingMethod,
    required this.protocolType,
    required this.versionNumber,
  }) : super(
          Uint8List.fromList(<int>[
            ...compressionMethod.bytes,
            ...encodingMethod.bytes,
            ...protocolType.bytes,
            ...versionNumber.bytes,
          ]),
        );

  /// Creates a instance of [FrameProtocolID] from the given [values].
  factory FrameProtocolID.fromValues({
    required CompressionMethod compressionMethod,
    required EncodingMethod encodingMethod,
    required ProtocolType protocolType,
    required VersionNumber versionNumber,
  }) {
    return FrameProtocolID(
      compressionMethod: Uint8.fromInt(compressionMethod.value),
      encodingMethod: Uint8.fromInt(encodingMethod.value),
      protocolType: Uint8.fromInt(protocolType.value),
      versionNumber: Uint8.fromInt(versionNumber.value),
    );
  }

  /// Creates a instance of [FrameProtocolID] from the given [bytes].
  static UintReminder<FrameProtocolID> fromBytes(Uint8List bytes) {
    UintReminder<Uint8> compressionMethod = Uint8.fromBytes(bytes);
    UintReminder<Uint8> encodingMethod = Uint8.fromBytes(compressionMethod.reminder);
    UintReminder<Uint8> protocolType = Uint8.fromBytes(encodingMethod.reminder);
    UintReminder<Uint8> versionNumber = Uint8.fromBytes(protocolType.reminder);

    return UintReminder<FrameProtocolID>(
      FrameProtocolID(
        compressionMethod: compressionMethod.value,
        encodingMethod: encodingMethod.value,
        protocolType: protocolType.value,
        versionNumber: versionNumber.value,
      ),
      versionNumber.reminder,
    );
  }

  @override
  List<Object?> get props => <Object?>[compressionMethod, encodingMethod, protocolType, versionNumber];
}
