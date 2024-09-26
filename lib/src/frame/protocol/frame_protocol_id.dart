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

  factory FrameProtocolID.fromProtocolId(int protocolId) {
    Uint8List protocolIdBytes = Uint8List(4);
    ByteData byteData = ByteData.sublistView(protocolIdBytes)..setUint32(0, protocolId, Endian.big);


    FrameCompressionType compression = FrameCompressionType.fromValue(protocolIdBytes.sublist(0, 1)[0]);
    FrameEncodingType encoding = FrameEncodingType.fromValue(protocolIdBytes.sublist(1, 2)[0]);
    FrameProtocolType protocol = FrameProtocolType.fromValue(protocolIdBytes.sublist(2, 3)[0]);
    FrameVersionNumber version = FrameVersionNumber.fromValue(protocolIdBytes.sublist(3, 4)[0]);

    return FrameProtocolID(
      frameCompressionType: compression,
      frameEncodingType: encoding,
      frameProtocolType: protocol,
      frameVersionNumber: version,
    );
  }

  int get protocolId {
    return (frameCompressionType.value << 24) | (frameEncodingType.value << 16) | (frameProtocolType.value << 8) | frameVersionNumber.value;
  }

  @override
  String toString() {
    return 'FrameProtocolManager(compressionMethod: $frameCompressionType, encodingMethod: $frameEncodingType, protocolType: $frameProtocolType, versionNumber: $frameVersionNumber)';
  }
}
