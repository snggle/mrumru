import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';

class FskEncoder {
  final AudioSettingsModel audioSettingsModel;

  FskEncoder(this.audioSettingsModel);

  List<List<int>> encodeBinaryToFrequencies(String binary) {
    List<int> baseFrequencies = encodeBinaryDataToFrequencies(binary);
    List<List<int>> chunkedFrequenciesList = _chunkFrequencies(baseFrequencies)
      ..insert(0, audioSettingsModel.startFrequencies)
      ..add(audioSettingsModel.endFrequencies);

    return chunkedFrequenciesList;
  }

  List<List<int>> _chunkFrequencies(List<int> baseFrequencies) {
    int chunksCount = audioSettingsModel.chunksCount;
    int maxFrequency = audioSettingsModel.maxFrequency;
    int frequencyGap = audioSettingsModel.frequencyGap;

    List<List<int>> chunkFrequenciesList = <List<int>>[];
    for (int i = 0; i < baseFrequencies.length; i += chunksCount) {
      chunkFrequenciesList.add(baseFrequencies.sublist(i, i + chunksCount));
    }

    List<List<int>> chunkedFrequenciesList = <List<int>>[];
    for (List<int> chunkFrequencies in chunkFrequenciesList) {
      List<int> chunkedFrequencies = <int>[];
      for (int i = 0; i < chunkFrequencies.length; i++) {
        int frequency = chunkFrequencies[i];
        int chunkShift = i * (maxFrequency + frequencyGap);
        int chunkFrequency = frequency + chunkShift;
        chunkedFrequencies.add(chunkFrequency);
      }
      chunkedFrequenciesList.add(chunkedFrequencies);
    }
    return chunkedFrequenciesList;
  }

  List<int> encodeBinaryDataToFrequencies(String binaryData) {
    int bitsPerFrequency = audioSettingsModel.bitsPerFrequency;
    int baseFrequency = audioSettingsModel.baseFrequency;
    int frequencyGap = audioSettingsModel.frequencyGap;

    List<int> encodedFrequencies = <int>[];
    int frequenciesCount = (binaryData.length / bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequencyStartIndex = i * bitsPerFrequency;
      int frequencyEndIndex = frequencyStartIndex + bitsPerFrequency;

      String frequencyBits = binaryData.substring(frequencyStartIndex, math.min(frequencyEndIndex, binaryData.length)).padRight(bitsPerFrequency, '0');
      int frequency = baseFrequency + int.parse(frequencyBits, radix: 2) * frequencyGap;
      encodedFrequencies.add(frequency);
    }
    return encodedFrequencies;
  }
}
