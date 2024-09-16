import 'package:mrumru/src/shared/enums/compression_enum.dart';
import 'package:mrumru/src/shared/enums/encoding_enum.dart';
import 'package:mrumru/src/shared/enums/protocol_type_enum.dart';
import 'package:mrumru/src/shared/enums/version_number_enum.dart';

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

  int get protocolId {
    return (compressionEnum.value << 24) | (encodingEnum.value << 16) | (protocolTypeEnum.value << 8) | versionNumberEnum.value;
  }

  factory FrameProtocolManager.defaultProtocol() {
    return const FrameProtocolManager(
      compressionEnum: CompressionEnum.noCompression,
      encodingEnum: EncodingEnum.defaultMethod,
      protocolTypeEnum: ProtocolTypeEnum.rawDataTransfer,
      versionNumberEnum: VersionNumberEnum.firstDefault,
    );
  }

  factory FrameProtocolManager.fromProtocolId(int protocolId) {
    final CompressionEnum compression = CompressionEnum.fromValue((protocolId >> 24) & 0xFF);
    final EncodingEnum encoding = EncodingEnum.fromValue((protocolId >> 16) & 0xFF);
    final ProtocolTypeEnum protocol = ProtocolTypeEnum.fromValue((protocolId >> 8) & 0xFF);
    final VersionNumberEnum version = VersionNumberEnum.fromValue(protocolId & 0xFF);

    return FrameProtocolManager(
      compressionEnum: compression,
      encodingEnum: encoding,
      protocolTypeEnum: protocol,
      versionNumberEnum: version,
    );
  }

  @override
  String toString() {
    return 'FrameProtocolManager(compressionMethod: $compressionEnum, encodingMethod: $encodingEnum, protocolType: $protocolTypeEnum, versionNumber: $versionNumberEnum)';
  }
}
