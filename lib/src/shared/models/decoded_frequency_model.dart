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
    int frequency = audioSettingsModel.parseChunkFrequencyToFrequency(chunkFrequency, chunkIndex);

    print('Calculating base frequency($frequency) from $chunkFrequency at chunk index $chunkIndex');

    return _convertFrequencyToBits(frequency, audioSettingsModel);
  }

  String _convertFrequencyToBits(int correctedFrequency, AudioSettingsModel audioSettingsModel) {
    int bitsCount = (correctedFrequency - audioSettingsModel.baseFrequency) ~/ audioSettingsModel.baseFrequencyGap;
    return bitsCount.toRadixString(2).padLeft(audioSettingsModel.bitsPerFrequency, '0');
  }

  @override
  List<Object?> get props => <Object?>[chunkFrequency, chunkIndex];
}
