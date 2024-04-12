import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class FrameModel extends Equatable {
  final int frameIndex;
  final int framesCount;
  final String rawData;
  final FrameSettingsModel frameSettings;
  final String binaryData;
  final String checksum;

  FrameModel({
    required this.frameIndex,
    required this.framesCount,
    required this.rawData,
    required this.frameSettings,
  })  : binaryData = BinaryUtils.convertAsciiToBinary(rawData),
        checksum = CryptoUtils.calcChecksum(text: rawData, length: frameSettings.checksumBitsLength);

  factory FrameModel.fromBinaryString(String binaryString) {
    FrameSettingsModel frameSettings = FrameSettingsModel.withDefaults();
    int bitsCount = 0;
    String frameIndexBinary = binaryString.substring(0, bitsCount += frameSettings.frameIndexBitsLength);
    String framesCountBinary = binaryString.substring(bitsCount, bitsCount += frameSettings.framesCountBitsLength);
    String dataBinary = binaryString.substring(bitsCount, bitsCount += frameSettings.dataBitsLength);
    String expectedChecksum = binaryString.substring(bitsCount, bitsCount += frameSettings.checksumBitsLength);

    while (dataBinary.startsWith('0' * 8)) {
      dataBinary = dataBinary.substring(8);
    }

    String actualChecksum = CryptoUtils.calcChecksum(text: BinaryUtils.convertBinaryToAscii(dataBinary), length: frameSettings.checksumBitsLength);
    if (expectedChecksum != actualChecksum) {
      throw InvalidChecksumException('Checksum Mismatch: Expected $expectedChecksum but got $actualChecksum in frame $frameIndexBinary from data $dataBinary');
    }

    return FrameModel(
      frameIndex: int.parse(frameIndexBinary, radix: 2),
      framesCount: int.parse(framesCountBinary, radix: 2),
      rawData: BinaryUtils.convertBinaryToAscii(dataBinary),
      frameSettings: frameSettings,
    );
  }

  String get binaryString {
    return binaryList.join();
  }

  int getTransferWavLength(AudioSettingsModel audioSettingsModel) =>
      (framesCount * 56 / 2 * audioSettingsModel.sampleSize * audioSettingsModel.sampleRate).toInt();

  List<String> get binaryList {
    String frameNumberBinary = BinaryUtils.parseIntToPaddedBinary(frameIndex, frameSettings.frameIndexBitsLength);
    String framesCountBinary = BinaryUtils.parseIntToPaddedBinary(framesCount, frameSettings.framesCountBitsLength);
    String frameDataBinary = BinaryUtils.convertAsciiToBinary(rawData).padLeft(frameSettings.dataBitsLength, '0');
    String frameChecksumBinary = checksum;
    return <String>[frameNumberBinary, framesCountBinary, frameDataBinary, frameChecksumBinary];
  }

  @override
  List<Object?> get props => <Object>[frameIndex, framesCount, binaryData, rawData];
}
