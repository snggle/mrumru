import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/correlation/chunk_frequency_correlation_model.dart';
import 'package:mrumru/src/shared/utils/math_utils.dart';

class ChunkFrequencyCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  ChunkFrequencyCorrelationCalculator({
    required this.audioSettingsModel,
    required this.symbolDurationCalculator,
  });

  int findFrequencyWithHighestCorrelation(List<double> frequencySamples, int chunkIndex) {
    List<ChunkFrequencyCorrelationModel> frequenciesCorrelations = _calculateCorrelations(frequencySamples, chunkIndex);
    ChunkFrequencyCorrelationModel highestChunkFrequencyCorrelationModel =
    frequenciesCorrelations.reduce((ChunkFrequencyCorrelationModel a, ChunkFrequencyCorrelationModel b) {
      return b.correlation > a.correlation ? b : a;
    });
    return highestChunkFrequencyCorrelationModel.chunkFrequency;
  }

  List<ChunkFrequencyCorrelationModel> _calculateCorrelations(List<double> samples, int chunkIndex) {
    return audioSettingsModel.getPossibleFrequenciesForChunk(chunkIndex).map((int chunkFrequency) {
      double correlation = _calculateCorrelation(samples, chunkFrequency);
      return ChunkFrequencyCorrelationModel(chunkFrequency: chunkFrequency, correlation: correlation);
    }).toList();
  }

  double _calculateCorrelation(List<double> samples, int chunkFrequency) {
    double angleStep = _calculateAngleStep(chunkFrequency);
    return _calculateAmplitude(samples, angleStep, chunkFrequency);
  }

  double _calculateAngleStep(int chunkFrequency) => (2 * math.pi * chunkFrequency) / audioSettingsModel.sampleRate;

  double _calculateAmplitude(List<double> samples, double angleStep, int chunkFrequency) {
    double sumCos = 0.0;
    double sumSin = 0.0;
    int symbolSize = (_sampleRate * symbolDurationCalculator(chunkFrequency).inMilliseconds / AudioSettingsModel.millisecondsInSeconds).toInt();

    for (int i = 0; i < samples.length; i++) {
      double normalizedSample = samples[i] / audioSettingsModel.amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / symbolSize - 0.5);
      sumCos += normalizedSample * math.cos(i * angleStep) * sincValue;
      sumSin += normalizedSample * math.sin(i * angleStep) * sincValue;
    }
    double amplitude = 2.0 * math.sqrt(sumCos * sumCos + sumSin * sumSin) / samples.length;
    return amplitude;
  }
}
