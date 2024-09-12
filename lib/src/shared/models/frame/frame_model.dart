import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameModel extends Equatable {
  final int frameIndex;
  final int frameLength;
  final int framesCount;
  final int protocolId;
  final int sessionId;
  final int compressionMethod;
  final int encodingMethod;
  final int protocolType;
  final int versionNumber;
  final int compositeChecksum;
  final String rawData;
  final String frameChecksum;

  FrameModel({
    required this.frameIndex,
    required this.frameLength,
    required this.framesCount,
    required this.protocolId,
    required this.sessionId,
    required this.compressionMethod,
    required this.encodingMethod,
    required this.protocolType,
    required this.versionNumber,
    required this.compositeChecksum,
    required this.rawData,
  }) : frameChecksum = CryptoUtils.calcChecksum(text: rawData, length: 16);

  factory FrameModel.fromBinaryString(String binaryString) {
    FrameSettingsModel frameSettings = FrameSettingsModel.withDefaults();
    int bitsCount = 0;
    String frameIndexBinary = binaryString.substring(0, bitsCount += frameSettings.frameIndexBitsLength);
    String frameLengthBinary = binaryString.substring(bitsCount, bitsCount += frameSettings.frameIndexBitsLength);
    String framesCountBinary = binaryString.substring(bitsCount, bitsCount += frameSettings.framesCountBitsLength);
    String protocolIdBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String sessionIdBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String compressionMethodBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String encodingMethodBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String protocolTypeBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String versionNumberBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String compositeChecksumBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String frameChecksumBinary = binaryString.substring(bitsCount, bitsCount += 16);

    Uint8List rawDataBytes = Uint8List.sublistView(Uint8List.fromList(binaryString.codeUnits), bitsCount);
    String rawData = BinaryUtils.convertBinaryToAscii(rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());

    return FrameModel(
      frameIndex: int.parse(frameIndexBinary, radix: 2),
      frameLength: int.parse(frameLengthBinary, radix: 2),
      framesCount: int.parse(framesCountBinary, radix: 2),
      protocolId: int.parse(protocolIdBinary, radix: 2),
      sessionId: int.parse(sessionIdBinary, radix: 2),
      compressionMethod: int.parse(compressionMethodBinary, radix: 2),
      encodingMethod: int.parse(encodingMethodBinary, radix: 2),
      protocolType: int.parse(protocolTypeBinary, radix: 2),
      versionNumber: int.parse(versionNumberBinary, radix: 2),
      compositeChecksum: int.parse(compositeChecksumBinary, radix: 2),
      rawData: rawData,
    );
  }

  String get binaryString {
    return binaryList.join();
  }

  List<String> get binaryList {
    String frameNumberBinary = BinaryUtils.parseIntToPaddedBinary(frameIndex, 16);
    String frameLengthBinary = BinaryUtils.parseIntToPaddedBinary(frameLength, 16);
    String framesCountBinary = BinaryUtils.parseIntToPaddedBinary(framesCount, 16);
    String protocolIdBinary = BinaryUtils.parseIntToPaddedBinary(protocolId, 32);
    String sessionIdBinary = BinaryUtils.parseIntToPaddedBinary(sessionId, 32);
    String compressionMethodBinary = BinaryUtils.parseIntToPaddedBinary(compressionMethod, 8);
    String encodingMethodBinary = BinaryUtils.parseIntToPaddedBinary(encodingMethod, 8);
    String protocolTypeBinary = BinaryUtils.parseIntToPaddedBinary(protocolType, 8);
    String versionNumberBinary = BinaryUtils.parseIntToPaddedBinary(versionNumber, 8);
    String compositeChecksumBinary = BinaryUtils.parseIntToPaddedBinary(compositeChecksum, 32);
    String frameChecksumBinary = frameChecksum;

    return <String>[
      frameNumberBinary,
      frameLengthBinary,
      framesCountBinary,
      protocolIdBinary,
      sessionIdBinary,
      compressionMethodBinary,
      encodingMethodBinary,
      protocolTypeBinary,
      versionNumberBinary,
      compositeChecksumBinary,
      frameChecksumBinary,
    ];
  }

  @override
  List<Object?> get props => <Object?>[
        frameIndex,
        frameLength,
        framesCount,
        protocolId,
        sessionId,
        compressionMethod,
        encodingMethod,
        protocolType,
        versionNumber,
        compositeChecksum,
        rawData,
        frameChecksum,
      ];
}
