import 'dart:typed_data';

import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';

class FrameProtocolID {
  final FrameCompressionType frameCompressionType;
  final FrameEncodingType frameEncodingType;
  final FrameProtocolType frameProtocolType;
  final FrameVersionNumber frameVersionNumber;

  const FrameProtocolID({
    required this.frameCompressionType,
    required this.frameEncodingType,
    required this.frameProtocolType,
    required this.frameVersionNumber,
  });

  factory FrameProtocolID.defaultProtocol() {
    return const FrameProtocolID(
      frameCompressionType: FrameCompressionType.noCompression,
      frameEncodingType: FrameEncodingType.defaultMethod,
      frameProtocolType: FrameProtocolType.rawDataTransfer,
      frameVersionNumber: FrameVersionNumber.firstDefault,
    );
  }

  /// Creates FrameProtocolID from Uint8List (4 bytes)
  factory FrameProtocolID.fromBytes(Uint8List bytes) {
    if (bytes.length != 4) {
      throw ArgumentError('Protocol ID must be exactly 4 bytes long');
    }

    return FrameProtocolID(
      frameCompressionType: FrameCompressionType.fromValue(bytes[0]),
      frameEncodingType: FrameEncodingType.fromValue(bytes[1]),
      frameProtocolType: FrameProtocolType.fromValue(bytes[2]),
      frameVersionNumber: FrameVersionNumber.fromValue(bytes[3]),
    );
  }

  /// Converts FrameProtocolID to Uint8List (4 bytes)
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      frameCompressionType.value,
      frameEncodingType.value,
      frameProtocolType.value,
      frameVersionNumber.value,
    ]);
  }

  /// Gets a combined protocol ID as an integer (32-bit value).
  int get protocolValue {
    return (frameCompressionType.value << 24) |
    (frameEncodingType.value << 16) |
    (frameProtocolType.value << 8) |
    frameVersionNumber.value;
  }

  /// Creates FrameProtocolID from a combined 32-bit integer value.
  factory FrameProtocolID.fromValue(int protocolId) {
    return FrameProtocolID(
      frameCompressionType: FrameCompressionType.fromValue((protocolId >> 24) & 0xFF),
      frameEncodingType: FrameEncodingType.fromValue((protocolId >> 16) & 0xFF),
      frameProtocolType: FrameProtocolType.fromValue((protocolId >> 8) & 0xFF),
      frameVersionNumber: FrameVersionNumber.fromValue(protocolId & 0xFF),
    );
  }

  @override
  String toString() {
    return 'FrameProtocolID(compressionMethod: $frameCompressionType, encodingMethod: $frameEncodingType, protocolType: $frameProtocolType, versionNumber: $frameVersionNumber)';
  }
}
