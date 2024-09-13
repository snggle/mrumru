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
    return (compressionEnum.index << 24) | (encodingEnum.index << 16) | (protocolTypeEnum.index << 8) | versionNumberEnum.index;
  }

  FrameProtocolManager fromProtocolId(int protocolId) {
    final CompressionEnum compression = CompressionEnum.values[(protocolId >> 24) & 0xFF];
    final EncodingEnum encoding = EncodingEnum.values[(protocolId >> 16) & 0xFF];
    final ProtocolTypeEnum protocol = ProtocolTypeEnum.values[(protocolId >> 8) & 0xFF];
    final VersionNumberEnum version = VersionNumberEnum.values[protocolId & 0xFF];

    return FrameProtocolManager(
      compressionMethod: compression,
      encodingMethod: encoding,
      protocolType: protocol,
      versionNumber: version,
    );
  }

  @override
  String toString() {
    return 'FrameProtocolManager(compressionMethod: $compressionEnum, encodingMethod: $encodingEnum, protocolType: $protocolTypeEnum, versionNumber: $versionNumberEnum)';
  }
}
