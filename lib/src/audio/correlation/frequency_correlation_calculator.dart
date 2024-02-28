import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/utils/math_utils.dart';

class FrequencyCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  FrequencyCorrelationCalculator({required this.audioSettingsModel});

  int findBestFrequency(List<double> frequencySamples, int chunkIndex) {
    List<_FrequencyCorrelation> correlations = _calculateCorrelations(frequencySamples, chunkIndex);
    return _findHighestFrequency(correlations).frequency;
  }

  List<_FrequencyCorrelation> _calculateCorrelations(List<double> samples, int chunkIndex) {
    return audioSettingsModel.possibleFrequencies.map((int frequency) {
      int chunkFrequency = frequency + chunkIndex * audioSettingsModel.frequencyRange;
      double correlation = _calculateCorrelation(samples, chunkFrequency);
      return _FrequencyCorrelation(frequency: chunkFrequency, correlation: correlation);
    }).toList();
  }

  _FrequencyCorrelation _findHighestFrequency(List<_FrequencyCorrelation> correlations) {
    return correlations.reduce((_FrequencyCorrelation max, _FrequencyCorrelation current) => current.correlation > max.correlation ? current : max);
  }

  double _calculateCorrelation(List<double> samples, int frequency) {
    double angleStep = _calculateAngleStep(frequency);
    Map<String, double> sums = _calculateSums(samples, angleStep);
    return _calculateAmplitude(sums, samples.length);
  }

  double _calculateAngleStep(int frequency) => (2 * math.pi * frequency) / audioSettingsModel.sampleRate;

  Map<String, double> _calculateSums(List<double> samples, double angleStep) {
    double sumCos = 0.0, sumSin = 0.0;
    for (int i = 0; i < samples.length; i++) {
      double normalizedSample = samples[i] / audioSettingsModel.amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / samples.length - 0.5);
      sumCos += normalizedSample * math.cos(i * angleStep) * sincValue;
      sumSin += normalizedSample * math.sin(i * angleStep) * sincValue;
    }
    return <String, double>{'sumCos': sumCos, 'sumSin': sumSin};
  }

  double _calculateAmplitude(Map<String, double> sums, int sampleCount) {
    return 2.0 * math.sqrt(sums['sumCos']! * sums['sumCos']! + sums['sumSin']! * sums['sumSin']!) / sampleCount;
  }
}

class _FrequencyCorrelation extends Equatable {
  final int frequency;
  final double correlation;

  const _FrequencyCorrelation({required this.frequency, required this.correlation});

  @override
  List<Object?> get props => <Object?>[frequency, correlation];
}
