import 'package:mrumru/mrumru.dart';

class FskDecoder {
  final int baseFrequency;
  final int frequencyGap;
  final int bitsPerFrequency;
  final int chunksCount;
  final int frequencyRange;

  FskDecoder(AudioSettingsModel audioSettingsModel)
      : baseFrequency = audioSettingsModel.baseFrequency,
        frequencyGap = audioSettingsModel.frequencyGap,
        bitsPerFrequency = audioSettingsModel.bitsPerFrequency,
        chunksCount = audioSettingsModel.chunksCount,
        frequencyRange = audioSettingsModel.frequencyRange;

  String decodeFrequenciesToBinary(List<int> chunkFrequencies) {
    StringBuffer decodedBinaryData = StringBuffer();
    int chunkSize = chunkFrequencies.length ~/ chunksCount;

    for (int chunkFrequencyIndex = 0; chunkFrequencyIndex < chunkFrequencies.length; chunkFrequencyIndex++) {
      int chunkFrequency = chunkFrequencies[chunkFrequencyIndex];
      int currentChunk = chunkFrequencyIndex ~/ chunkSize;
      int frequency = chunkFrequency - currentChunk * frequencyRange;

      String chunkBits = _convertFrequencyToBits(frequency);
      decodedBinaryData.write(chunkBits);
    }

    return decodedBinaryData.toString();
  }

  String _convertFrequencyToBits(int correctedFrequency) {
    int bits = ((correctedFrequency - baseFrequency) / frequencyGap).round();
    return bits.toRadixString(2).padLeft(bitsPerFrequency, '0');
  }
}
