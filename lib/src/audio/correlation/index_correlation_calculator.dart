import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class IndexCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  IndexCorrelationCalculator({required this.audioSettingsModel});

  int findBestIndex(List<double> wave, List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = _createTemplateSineWaves(templateFrequencies);
    List<_IndexCorrelation> correlations = _calculateCorrelations(wave, templateSineWaves);

    _IndexCorrelation maxCorrelation = _findMaxCorrelation(correlations);
    return maxCorrelation.index + audioSettingsModel.sampleSize;
  }

  List<List<double>> _createTemplateSineWaves(List<int> frequencies) {
    return frequencies.map((int freq) {
      return List<double>.generate(audioSettingsModel.sampleSize, (int i) => math.sin(2 * math.pi * freq * i / audioSettingsModel.sampleRate)).toList();
    }).toList();
  }

  List<_IndexCorrelation> _calculateCorrelations(List<double> wave, List<List<double>> templates) {
    List<_IndexCorrelation> correlations = <_IndexCorrelation>[];

    for (int i = 0; i <= wave.length - audioSettingsModel.sampleSize; i += 50) {
      List<double> window = wave.sublist(i, i + audioSettingsModel.sampleSize);
      double correlation = _calculateWindowCorrelation(window, templates);
      correlations.add(_IndexCorrelation(index: i, correlation: correlation));
    }

    return correlations;
  }

  double _calculateWindowCorrelation(List<double> window, List<List<double>> templates) {
    return templates.fold(0.0, (double total, List<double> template) {
      double sum = 0.0;
      for (int j = 0; j < audioSettingsModel.sampleSize; j++) {
        sum += window[j] * template[j];
      }
      return total + sum.abs();
    });
  }

  _IndexCorrelation _findMaxCorrelation(List<_IndexCorrelation> correlations) {
    return correlations.reduce((_IndexCorrelation a, _IndexCorrelation b) => a.correlation > b.correlation ? a : b);
  }
}

class _IndexCorrelation extends Equatable {
  final int index;
  final double correlation;

  const _IndexCorrelation({required this.index, required this.correlation});

  @override
  List<Object> get props => <Object>[index, correlation];
}
