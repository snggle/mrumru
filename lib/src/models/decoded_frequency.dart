import 'package:mrumru/src/models/audio_settings.dart';

class DecodedFrequency {
  final int chunkFrequency;
  final int chunkIndex;

  const DecodedFrequency({
    required this.chunkFrequency,
    required this.chunkIndex,
  });

  String calcBinary(AudioSettingsModel audioSettingsModel) {
    int frequency = chunkFrequency - chunkIndex * audioSettingsModel.frequencyRange;
    String chunkBits = _convertFrequencyToBits(frequency, audioSettingsModel);
    return chunkBits;
  }

  String _convertFrequencyToBits(int correctedFrequency, AudioSettingsModel audioSettingsModel) {
    int bits = ((correctedFrequency - audioSettingsModel.baseFrequency) / audioSettingsModel.frequencyGap).round();
    return bits.toRadixString(2).padLeft(audioSettingsModel.bitsPerFrequency, '0');
  }
}
