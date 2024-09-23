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

  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      frameCompressionType.value,
      frameEncodingType.value,
      frameProtocolType.value,
      frameVersionNumber.value,
    ]);
  }

  @override
  String toString() {
    return 'FrameProtocolID(compressionMethod: $frameCompressionType, encodingMethod: $frameEncodingType, protocolType: $frameProtocolType, versionNumber: $frameVersionNumber)';
  }
}