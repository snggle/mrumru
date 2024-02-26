import 'package:mrumru/src/models/audio_settings.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

class FskEncoder {
  final int bitsPerFrequency;
  final int baseFrequency;
  final int chunksCount;
  final int maxFrequency;
  final int frequencyGap;

  FskEncoder(AudioSettingsModel audioSettingsModel)
      : bitsPerFrequency = audioSettingsModel.bitsPerFrequency,
        baseFrequency = audioSettingsModel.baseFrequency,
        chunksCount = audioSettingsModel.chunksCount,
        maxFrequency = audioSettingsModel.maxFrequency,
        frequencyGap = audioSettingsModel.frequencyGap;

  List<int> encodeBinaryDataToFrequencies(String binaryData) {
    String tmpBinary = BinaryUtils.splitAndCombine(binaryData, bitsPerFrequency, chunksCount);
    List<int> encodedFrequencies = <int>[];
    int chunkSize = tmpBinary.length ~/ chunksCount;
    int frequenciesCount = (tmpBinary.length / bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequencyStartIndex = i * bitsPerFrequency;
      String frequencyBits = _extractFrequencyBits(frequencyStartIndex, tmpBinary);
      int frequency = baseFrequency + int.parse(frequencyBits, radix: 2) * frequencyGap;
      int chunkShift = (frequencyStartIndex / chunkSize).floor() * (maxFrequency + frequencyGap);
      int chunkFrequency = frequency + chunkShift;

      encodedFrequencies.add(chunkFrequency);
    }

    printChunkFrequencies(encodedFrequencies);
    return encodedFrequencies;
  }

  void printChunkFrequencies(List<int> frequencies) {
    int frequenciesPerChunk = frequencies.length ~/ chunksCount;
    List<List<int>> chunks = <List<int>>[];
    for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
      List<int> chunkBinaries = <int>[];
      for (int i = 0; i < frequenciesPerChunk; i++) {
        int index = chunkIndex * frequenciesPerChunk + i;
        chunkBinaries.add(frequencies[index]);
      }
      chunks.add(chunkBinaries);
    }
  }

  String _extractFrequencyBits(int frequencyStartIndex, String binaryData) {
    int frequencyEndIndex = frequencyStartIndex + bitsPerFrequency;

    if (frequencyEndIndex < binaryData.length) {
      return binaryData.substring(frequencyStartIndex, frequencyEndIndex);
    } else {
      String chunkBits = binaryData.substring(frequencyStartIndex, binaryData.length);
      return chunkBits.padRight(bitsPerFrequency, '0');
    }
  }
}
