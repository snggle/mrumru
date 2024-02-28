import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/models/correlation/frequency_correlation_model.dart';
import 'package:mrumru/src/utils/math_utils.dart';

class FrequencyCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  FrequencyCorrelationCalculator({required this.audioSettingsModel});

  int findBestFrequency(List<double> frequencySamples, int chunkIndex) {
    List<FrequencyCorrelationModel> frequencyCorrelations = _calculateFrequencyCorrelations(frequencySamples, chunkIndex);
    return _findHighestFrequency(frequencyCorrelations).frequency;
  }

  List<FrequencyCorrelationModel> _calculateFrequencyCorrelations(List<double> samples, int chunkIndex) {
    return audioSettingsModel.possibleFrequencies.map((int frequency) {
      int chunkFrequency = frequency + chunkIndex * audioSettingsModel.frequencyRange;
      double correlation = _calculateCorrelation(samples, chunkFrequency);
      return FrequencyCorrelationModel(frequency: chunkFrequency, correlation: correlation);
    }).toList();
  }

  double _calculateCorrelation(List<double> samples, int frequency) {
    double angleStep = _calculateAngleStep(frequency);
    return _calculateAmplitude(samples, angleStep);
  }

  double _calculateAngleStep(int frequency) => (2 * math.pi * frequency) / audioSettingsModel.sampleRate;

  double _calculateAmplitude(List<double> samples, double angleStep) {
    double sumCos = 0.0;
    double sumSin = 0.0;
    for (int i = 0; i < samples.length; i++) {
      double normalizedSample = samples[i] / audioSettingsModel.amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / samples.length - 0.5);
      sumCos += normalizedSample * math.cos(i * angleStep) * sincValue;
      sumSin += normalizedSample * math.sin(i * angleStep) * sincValue;
    }
    double amplitude = 2.0 * math.sqrt(sumCos * sumCos + sumSin * sumSin) / samples.length;
    return amplitude;
  }

  FrequencyCorrelationModel _findHighestFrequency(List<FrequencyCorrelationModel> correlations) {
    return correlations.reduce((FrequencyCorrelationModel a, FrequencyCorrelationModel b) => b.correlation > a.correlation ? b : a);
  }
}