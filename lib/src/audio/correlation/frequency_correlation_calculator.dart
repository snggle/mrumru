import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/utils/math_utils.dart';

class FrequencyCorrelationCalculator {
  final int sampleRate;
  final int frequencyRange;
  final double amplitude;
  final List<int> possibleFrequencies;

  FrequencyCorrelationCalculator({
    required AudioSettingsModel audioSettingsModel,
  }) : sampleRate = audioSettingsModel.sampleRate,
        frequencyRange = audioSettingsModel.frequencyRange,
        amplitude = audioSettingsModel.amplitude,
        possibleFrequencies = audioSettingsModel.possibleFrequencies;

  int findBestFrequency(List<double> chunkFrequencySample, int chunkIndex) {
    List<_FrequencyCorrelation> frequencyCorrelations = _calculateFrequencyCorrelations(chunkFrequencySample, chunkIndex);
    int highestFrequency = frequencyCorrelations.reduce((_FrequencyCorrelation a, _FrequencyCorrelation b) {
      return a.correlation > b.correlation ? a : b;
    }).frequency;
    return highestFrequency;
  }

  List<_FrequencyCorrelation> _calculateFrequencyCorrelations(List<double> chunkFrequencySample, int chunkIndex) {
    List<_FrequencyCorrelation> frequencyCorrelations = <_FrequencyCorrelation>[];

    for (int possibleFrequency in possibleFrequencies) {
      int chunkFrequency = possibleFrequency + chunkIndex * frequencyRange;
      double correlation = _calculateCorrelationForFrequency(chunkFrequencySample, chunkFrequency);
      frequencyCorrelations.add(_FrequencyCorrelation(correlation: correlation, frequency: chunkFrequency));
    }

    return frequencyCorrelations;
  }

  double _calculateCorrelationForFrequency(List<double> samples, int frequency) {
    int sampleCount = samples.length;
    double angleStep = (2 * math.pi * frequency) / sampleRate;
    double sumCos = 0;
    double sumSin = 0;

    for (int i = 0; i < sampleCount; i++) {
      double sampleValue = samples[i] / amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / sampleCount - 0.5);

      sumCos += sampleValue * math.cos(i * angleStep) * sincValue;
      sumSin += sampleValue * math.sin(i * angleStep) * sincValue;
    }

    double calculatedAmplitude = 2 * math.sqrt(sumCos * sumCos + sumSin * sumSin) / sampleCount;
    return calculatedAmplitude;
  }
}


class _FrequencyCorrelation extends Equatable {
  final int frequency;
  final double correlation;

  const _FrequencyCorrelation({
    required this.frequency,
    required this.correlation,
  });

  @override
  List<Object?> get props => <Object>[frequency, correlation];
}