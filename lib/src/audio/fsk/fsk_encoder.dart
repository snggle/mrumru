import 'dart:math' as math;

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
      int chunkShift = (frequencyStartIndex ~/ chunkSize) * (maxFrequency + frequencyGap);
      encodedFrequencies.add(frequency + chunkShift);
    }
    printChunkFrequencies(encodedFrequencies);
    return encodedFrequencies;
  }

  void printChunkFrequencies(List<int> frequencies) {
    for (int i = 0; i < chunksCount; i++) {
      print('Chunk $i frequencies: ${frequencies.skip(i * frequencies.length ~/ chunksCount).take(frequencies.length ~/ chunksCount).toList()}');
    }
  }

  String _extractFrequencyBits(int frequencyStartIndex, String binaryData) {
    int frequencyEndIndex = frequencyStartIndex + bitsPerFrequency;
    return binaryData.substring(frequencyStartIndex, math.min(frequencyEndIndex, binaryData.length)).padRight(bitsPerFrequency, '0');
  }
}
