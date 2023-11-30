import 'package:mrumru/src/models/audio_settings.dart';

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
    List<int> encodedFrequencies = <int>[];
    int chunkSize = binaryData.length ~/ chunksCount;
    int frequenciesCount = (binaryData.length / bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequencyStartIndex = i * bitsPerFrequency;
      String frequencyBits = _extractFrequencyBits(frequencyStartIndex, binaryData);
      int frequency = baseFrequency + int.parse(frequencyBits, radix: 2) * frequencyGap;
      int chunkShift = (frequencyStartIndex / chunkSize).floor() * (maxFrequency + frequencyGap);
      int chunkFrequency = frequency + chunkShift;

      encodedFrequencies.add(chunkFrequency);
    }

    return encodedFrequencies;
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
