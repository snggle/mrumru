import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';

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
    String chunkedBinary = _chunkBinary(binaryData, bitsPerFrequency, chunksCount);
    List<int> encodedFrequencies = <int>[];
    int chunkSize = chunkedBinary.length ~/ chunksCount;
    int frequenciesCount = (chunkedBinary.length / bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequencyStartIndex = i * bitsPerFrequency;
      String frequencyBits = _extractFrequencyBits(frequencyStartIndex, chunkedBinary);
      int frequency = baseFrequency + int.parse(frequencyBits, radix: 2) * frequencyGap;
      int chunkShift = (frequencyStartIndex ~/ chunkSize) * (maxFrequency + frequencyGap);
      int chunkFrequency = frequency + chunkShift;
      encodedFrequencies.add(chunkFrequency);
    }
    return encodedFrequencies;
  }

  String _chunkBinary(String binary, int bitsPerFrequency, int chunksCount) {
    List<String> parts = <String>[];
    for (int i = 0; i < binary.length; i += bitsPerFrequency) {
      parts.add(binary.substring(i, i + bitsPerFrequency));
    }

    List<List<String>> chunks = List<List<String>>.generate(chunksCount, (_) => <String>[]);

    int chunkIndex = 0;
    for (String part in parts) {
      chunks[chunkIndex].add(part);
      chunkIndex = (chunkIndex + 1) % chunksCount;
    }

    return chunks.map((List<String> chunk) => chunk.join('')).join('');
  }

  String _extractFrequencyBits(int frequencyStartIndex, String binaryData) {
    int frequencyEndIndex = frequencyStartIndex + bitsPerFrequency;
    return binaryData.substring(frequencyStartIndex, math.min(frequencyEndIndex, binaryData.length)).padRight(bitsPerFrequency, '0');
  }
}
