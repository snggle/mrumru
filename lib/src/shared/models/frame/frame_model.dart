import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/exceptions/invalid_checksum_exception.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameModel extends Equatable {
  final int frameIndex;  // uint16
  final int frameLength; // uint16
  final int framesCount; // uint16
  final int protocolId;  // uint32
  final int sessionId;   // uint32
  final int compressionMethod; // uint8
  final int encodingMethod;    // uint8
  final int protocolType;      // uint8
  final int versionNumber;     // uint8
  final int compositeChecksum; // uint32
  final String rawData;        // dynamic, narazie uint32
  final String binaryData;
  final String frameChecksum;  // uint16

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
  }) : binaryData = BinaryUtils.convertAsciiToBinary(rawData),
        frameChecksum = CryptoUtils.calcChecksum(text: rawData, length: 16);

  factory FrameModel.fromBinaryString(String binaryString) {
    int bitsCount = 0;


    String frameIndexBinary = binaryString.substring(0, bitsCount += 16);
    String frameLengthBinary = binaryString.substring(bitsCount, bitsCount += 16);
    String framesCountBinary = binaryString.substring(bitsCount, bitsCount += 16);

    String protocolIdBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String sessionIdBinary = binaryString.substring(bitsCount, bitsCount += 32);

    String compressionMethodBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String encodingMethodBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String protocolTypeBinary = binaryString.substring(bitsCount, bitsCount += 8);
    String versionNumberBinary = binaryString.substring(bitsCount, bitsCount += 8);


    String compositeChecksumBinary = binaryString.substring(bitsCount, bitsCount += 32);
    String frameChecksumBinary = binaryString.substring(bitsCount, bitsCount += 16);

    String dataBinary = binaryString.substring(bitsCount);

    int frameIndex = int.parse(frameIndexBinary, radix: 2);
    int frameLength = int.parse(frameLengthBinary, radix: 2);
    int framesCount = int.parse(framesCountBinary, radix: 2);
    int protocolId = int.parse(protocolIdBinary, radix: 2);
    int sessionId = int.parse(sessionIdBinary, radix: 2);
    int compressionMethod = int.parse(compressionMethodBinary, radix: 2);
    int encodingMethod = int.parse(encodingMethodBinary, radix: 2);
    int protocolType = int.parse(protocolTypeBinary, radix: 2);
    int versionNumber = int.parse(versionNumberBinary, radix: 2);
    int compositeChecksum = int.parse(compositeChecksumBinary, radix: 2);
    String rawData = BinaryUtils.convertBinaryToAscii(dataBinary);

    String actualChecksum = CryptoUtils.calcChecksum(text: rawData, length: 16);
    if (frameChecksumBinary != actualChecksum) {
      throw InvalidChecksumException(
          'Checksum Mismatch: Expected $frameChecksumBinary but got $actualChecksum in frame $frameIndexBinary from data $dataBinary');
    }

    return FrameModel(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolId: protocolId,
      sessionId: sessionId,
      compressionMethod: compressionMethod,
      encodingMethod: encodingMethod,
      protocolType: protocolType,
      versionNumber: versionNumber,
      compositeChecksum: compositeChecksum,
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
  List<Object?> get props => <Object>[
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
    rawData
  ];
}
