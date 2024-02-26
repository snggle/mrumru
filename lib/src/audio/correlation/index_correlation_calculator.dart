import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class IndexCorrelationCalculator {
  final int sampleSize;
  final int sampleRate;

  IndexCorrelationCalculator({
    required AudioSettingsModel audioSettingsModel,
  }) : sampleSize = audioSettingsModel.sampleSize,
       sampleRate = audioSettingsModel.sampleRate;

  int findBestIndex(List<double> wave, List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = _getTemplateSineWaves(templateFrequencies);

    List<_IndexCorrelation> correlations = <_IndexCorrelation>[];

    for (int i = 0; i < wave.length - sampleSize; i++) {
      int windowStart = i;
      int windowEnd = i + sampleSize;
      List<double> window = wave.sublist(windowStart, windowEnd);
      double windowCorrelation = _calcCorrelation(window, templateSineWaves);
      correlations.add(_IndexCorrelation(correlation: windowCorrelation, index: windowStart));
    }

    _IndexCorrelation maxCorrelation = correlations.reduce((_IndexCorrelation a, _IndexCorrelation b) => a.correlation > b.correlation ? a : b);
    return maxCorrelation.index + sampleSize;
  }

  List<List<double>> _getTemplateSineWaves(List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = <List<double>>[];

    for (int freq in templateFrequencies) {
      List<double> t = List<double>.generate(sampleSize, (int i) => i / sampleRate);
      List<double> sineWave = t.map((double ti) => math.sin(2 * math.pi * freq * ti)).toList();

      templateSineWaves.add(sineWave);
    }

    return templateSineWaves;
  }

  double _calcCorrelation(List<double> window, List<List<double>> templateSineWaves) {
    double windowCorrelation = 0.0;

    for (List<double> template in templateSineWaves) {
      double sum = 0.0;
      for (int j = 0; j < sampleSize; j++) {
        sum += window[j] * template[j];
      }
      windowCorrelation += sum.abs();
    }

    return windowCorrelation;
  }
}

class _IndexCorrelation extends Equatable {
  final int index;
  final double correlation;

  const _IndexCorrelation({required this.index, required this.correlation});

  @override
  List<Object?> get props => <Object?>[index, correlation];
}
