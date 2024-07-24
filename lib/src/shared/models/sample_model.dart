import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:mrumru/src/audio/recorder/correlation/chunk_frequency_correlation_calculator.dart';
import 'package:mrumru/src/shared/models/audio_settings_model.dart';

/// The [SampleModel] class is responsible for holding the chunked frequencies and generating the wave samples.
class SampleModel extends Equatable {
  /// The chunked frequencies used to calculate wave.
  final List<int> chunkedFrequencies;

  /// The settings model for audio configuration.
  final AudioSettingsModel audioSettingsModel;

  /// Creates an instance of [SampleModel].
  const SampleModel({required this.chunkedFrequencies, required this.audioSettingsModel});

  /// Creates an instance of [SampleModel] from a wave.
  factory SampleModel.fromWave(List<double> sampleWave, AudioSettingsModel audioSettingsModel) {
    ChunkFrequencyCorrelationCalculator chunkFrequencyCorrelationCalculator = ChunkFrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    List<int> chunkedFrequencies = List<int>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int chunkedFrequency = chunkFrequencyCorrelationCalculator.findFrequencyWithHighestCorrelation(sampleWave, chunkIndex);
      return audioSettingsModel.removeDynamicGap(chunkedFrequency);
    });
    return SampleModel(chunkedFrequencies: chunkedFrequencies, audioSettingsModel: audioSettingsModel);
  }

  /// This method calculates the binary data from the chunked frequencies.
  String calcBinary() {
    StringBuffer binary = StringBuffer();
    for (int chunkIndex = 0; chunkIndex < chunkedFrequencies.length; chunkIndex++) {
      int chunkedFrequency = chunkedFrequencies[chunkIndex];
      int baseFrequency = audioSettingsModel.parseChunkFrequencyToFrequency(chunkedFrequency, chunkIndex);

      int frequencyValueDec = (baseFrequency - audioSettingsModel.firstFrequency) ~/ audioSettingsModel.baseFrequencyGap;
      String frequencyValueBin = frequencyValueDec.toRadixString(2).padLeft(audioSettingsModel.bitsPerFrequency, '0');

      binary.write(frequencyValueBin);
    }

    return binary.toString();
  }

  /// This method calculate the wave from the chunked frequencies.
  List<double> calcWave() {
    List<double> wave = <double>[];

    for (int frequency in chunkedFrequencies) {
      List<double> frequencyWave = _buildFrequencyWave(frequency);
      wave.addAll(frequencyWave);
    }

    return _sumChunkedWave(wave);
  }

  /// Sums waves for chunks resulting in a single wave that is used for audio emission.
  List<double> _sumChunkedWave(List<double> wave) {
    int chunksLength = chunkedFrequencies.length;

    int splitLength = wave.length ~/ chunksLength;
    int remainder = wave.length % chunksLength;

    List<List<double>> splitSamples = <List<double>>[];
    int start = 0;
    int end = splitLength;

    for (int i = 0; i < chunksLength; i++) {
      if (remainder > 0) {
        end += 1;
        remainder -= 1;
      }
      splitSamples.add(wave.sublist(start, end));
      start = end;
      end += splitLength;
    }

    int maxLength = splitSamples.map((List<double> samples) => samples.length).reduce(max);
    List<double> summedSamples = List<double>.filled(maxLength, 0.0);

    for (List<double> samples in splitSamples) {
      for (int i = 0; i < samples.length; i++) {
        summedSamples[i] += samples[i];
      }
    }

    return summedSamples;
  }

  /// This method generates a list of samples for the specified frequency, applying a fade effect.
  List<double> _buildFrequencyWave(int frequency) {
    List<double> frequencyWave = <double>[];

    for (int i = 0; i < audioSettingsModel.sampleSize; i++) {
      double angle = (2 * pi * i * frequency) / audioSettingsModel.sampleRate;
      double fadeMultiplier = _calcFadeMultiplier(i);
      frequencyWave.add(audioSettingsModel.amplitude * fadeMultiplier * sin(angle));
    }

    return frequencyWave;
  }

  /// This method applies a fade effect to the samples based on the fade duration and sample rate.
  double _calcFadeMultiplier(int index) {
    double fadeDurationInSeconds = audioSettingsModel.fadeDuration.inMilliseconds / AudioSettingsModel.millisecondsInSeconds;
    int fadeSize = (audioSettingsModel.sampleRate * fadeDurationInSeconds).toInt();
    double fadeMultiplier = 1.0;

    if (index < fadeSize) {
      fadeMultiplier = index / fadeSize;
    } else if (index > audioSettingsModel.sampleSize - fadeSize) {
      fadeMultiplier = (audioSettingsModel.sampleSize - index) / fadeSize;
    }

    return fadeMultiplier;
  }

  @override
  List<Object?> get props => <Object?>[chunkedFrequencies, audioSettingsModel];
}
