import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class DecodedFrequencyModel extends Equatable {
  final int chunkFrequency;
  final int chunkIndex;

  const DecodedFrequencyModel({
    required this.chunkFrequency,
    required this.chunkIndex,
  });

  String calcBinary(AudioSettingsModel audioSettingsModel) {
    int correctedFrequency = _calculateCorrectedFrequency(audioSettingsModel);
    return _convertFrequencyToBits(correctedFrequency, audioSettingsModel);
  }

  int _calculateCorrectedFrequency(AudioSettingsModel audioSettingsModel) {
    return chunkFrequency - chunkIndex * audioSettingsModel.frequencyRange;
  }

  String _convertFrequencyToBits(int correctedFrequency, AudioSettingsModel audioSettingsModel) {
    int bitsCount = (correctedFrequency - audioSettingsModel.baseFrequency) ~/ audioSettingsModel.frequencyGap;
    return bitsCount.toRadixString(2).padLeft(audioSettingsModel.bitsPerFrequency, '0');
  }

  @override
  List<Object?> get props => <Object?>[chunkFrequency, chunkIndex];
}
