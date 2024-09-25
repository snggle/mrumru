import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';

class FrameProtocolManager {
  final CompressionEnum compressionEnum;
  final EncodingEnum encodingEnum;
  final ProtocolTypeEnum protocolTypeEnum;
  final VersionNumberEnum versionNumberEnum;

  const FrameProtocolManager({
    required this.compressionEnum,
    required this.encodingEnum,
    required this.protocolTypeEnum,
    required this.versionNumberEnum,
  });

  factory FrameProtocolManager.defaultProtocol() {
    return const FrameProtocolManager(
      compressionEnum: CompressionEnum.noCompression,
      encodingEnum: EncodingEnum.defaultMethod,
      protocolTypeEnum: ProtocolTypeEnum.rawDataTransfer,
      versionNumberEnum: VersionNumberEnum.firstDefault,
    );
  }

  factory FrameProtocolManager.fromProtocolId(int protocolId) {
    CompressionEnum compression = CompressionEnum.fromValue((protocolId >> 24) & 0xFF);
    EncodingEnum encoding = EncodingEnum.fromValue((protocolId >> 16) & 0xFF);
    ProtocolTypeEnum protocol = ProtocolTypeEnum.fromValue((protocolId >> 8) & 0xFF);
    VersionNumberEnum version = VersionNumberEnum.fromValue(protocolId & 0xFF);

    return FrameProtocolManager(
      compressionEnum: compression,
      encodingEnum: encoding,
      protocolTypeEnum: protocol,
      versionNumberEnum: version,
    );
  }

  int get protocolId {
    return (compressionEnum.value << 24) | (encodingEnum.value << 16) | (protocolTypeEnum.value << 8) | versionNumberEnum.value;
  }

  @override
  String toString() {
    return 'FrameProtocolManager(compressionMethod: $compressionEnum, encodingMethod: $encodingEnum, protocolType: $protocolTypeEnum, versionNumber: $versionNumberEnum)';
  }
}
