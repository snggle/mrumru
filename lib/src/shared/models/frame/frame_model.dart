import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameModel extends Equatable {
  final int frameIndex;
  final int frameLength;
  final int framesCount;
  final int compositeChecksum;
  final String rawData;
  final String frameChecksum;
  final FrameProtocolManager protocolManager;

  FrameModel({
    required this.frameIndex,
    required this.frameLength,
    required this.framesCount,
    required this.compositeChecksum,
    required this.rawData,
    required this.protocolManager,
  }) : frameChecksum = CryptoUtils.calcChecksum(text: rawData, length: 16);

  factory FrameModel.fromBinaryString(String binaryString) {
    int bitsCount = 0;
    String frameIndexBinary = binaryString.substring(0, bitsCount += 8);
    String frameLengthBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String framesCountBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String compositeChecksumBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String frameChecksumBinary = binaryString.substring(bitsCount, bitsCount += 16);

    String protocolIdBinary = binaryString.substring(bitsCount, bitsCount += 32);
    int protocolId = int.parse(protocolIdBinary, radix: 2);
    FrameProtocolManager protocolManager = FrameProtocolManager.fromProtocolId(protocolId);

    Uint8List rawDataBytes = Uint8List.sublistView(Uint8List.fromList(binaryString.codeUnits), bitsCount);
    String rawData = BinaryUtils.convertBinaryToAscii(rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());

    return FrameModel(
      frameIndex: int.parse(frameIndexBinary, radix: 2),
      frameLength: int.parse(frameLengthBinary, radix: 2),
      framesCount: int.parse(framesCountBinary, radix: 2),
      compositeChecksum: int.parse(compositeChecksumBinary, radix: 2),
      rawData: rawData,
      protocolManager: protocolManager,
    );
  }

  String get binaryString {
    return binaryList.join();
  }

  List<String> get binaryList {
    String frameIndexBinary = BinaryUtils.parseIntToPaddedBinary(frameIndex, 8);
    String frameLengthBinary = BinaryUtils.parseIntToPaddedBinary(frameLength, 8);
    String framesCountBinary = BinaryUtils.parseIntToPaddedBinary(framesCount, 8);
    String compositeChecksumBinary = BinaryUtils.parseIntToPaddedBinary(compositeChecksum, 32);
    String frameChecksumBinary = frameChecksum;
    String protocolBinary = BinaryUtils.parseIntToPaddedBinary(protocolManager.protocolId, 32);

    return <String>[
      frameIndexBinary,
      frameLengthBinary,
      framesCountBinary,
      compositeChecksumBinary,
      frameChecksumBinary,
      protocolBinary,
    ];
  }

  int calculateTransferWavLength(AudioSettingsModel audioSettingsModel) {
    return (framesCount * frameLength / 2 * audioSettingsModel.sampleSize * audioSettingsModel.sampleRate).toInt();
  }

  @override
  List<Object?> get props => <Object?>[
        frameIndex,
        frameLength,
        framesCount,
        compositeChecksum,
        rawData,
        frameChecksum,
        protocolManager,
      ];
}
