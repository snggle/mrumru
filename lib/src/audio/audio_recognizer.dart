import 'dart:math' as math;

import 'package:equatable/equatable.dart';

class IndexCorrelation extends Equatable {
  final int index;
  final double correlation;

  const IndexCorrelation({required this.index, required this.correlation});

  @override
  List<Object?> get props => <Object?>[index, correlation];
}

class AudioRecognizer {
  final int sampleSize;
  final int sampleRate;
  final List<int> startFrequencies;
  final List<int> endFrequencies;
  final int maxStartOffset;
  final double windowLength;
  final int windowSize;

  AudioRecognizer({
    required this.sampleSize,
    required this.sampleRate,
    required this.startFrequencies,
    required this.endFrequencies,
    int? maxStartOffset,
    this.windowLength = 0.5,
  })  : maxStartOffset = maxStartOffset ?? (5 * windowLength).toInt(),
        windowSize = (windowLength * sampleRate).toInt();

  List<double> trim(List<double> wave) {
    int firstIndex = _findFirstIndex(wave);
    int lastIndex = _findLastIndex(wave);

    List<double> trimmed = wave.sublist(firstIndex, lastIndex);
    int diff = trimmed.length % sampleSize;

    if(sampleSize / 2 > diff) {
      trimmed = wave.sublist(firstIndex, lastIndex + diff);
    } else {
      trimmed = wave.sublist(firstIndex, lastIndex - diff);
    }

    return trimmed;
  }

  int _findFirstIndex(List<double> wave) {
    List<List<double>> templateSineWaves = _getTemplateSineWaves(startFrequencies);

    List<IndexCorrelation> correlations = <IndexCorrelation>[];

    for (int i = 0; i < math.min(wave.length - windowSize, (maxStartOffset * sampleRate).toInt()); i++) {
      int windowStart = i;
      int windowEnd = i + windowSize;
      List<double> window = wave.sublist(windowStart, windowEnd);
      double windowCorrelation = _calcCorrelation(window, templateSineWaves);
      correlations.add(IndexCorrelation(correlation: windowCorrelation, index: windowStart));
    }

    IndexCorrelation maxCorrelation = correlations.reduce((IndexCorrelation a, IndexCorrelation b) => a.correlation > b.correlation ? a : b);
    return maxCorrelation.index + sampleSize;
  }

  int _findLastIndex(List<double> wave) {
    List<List<double>> templateSineWaves = _getTemplateSineWaves(endFrequencies);

    List<IndexCorrelation> correlations = <IndexCorrelation>[];

    for (int i = 0; i < math.min(wave.length - windowSize, (maxStartOffset * sampleRate).toInt()); i++) {
      int windowStart = wave.length - windowSize - i;
      int windowEnd = wave.length - i;

      List<double> window = wave.sublist(windowStart, windowEnd);
      double windowCorrelation = _calcCorrelation(window, templateSineWaves);
      correlations.add(IndexCorrelation(correlation: windowCorrelation, index: windowStart));
    }

    IndexCorrelation maxCorrelation = correlations.reduce((IndexCorrelation a, IndexCorrelation b) => a.correlation > b.correlation ? a : b);
    return maxCorrelation.index;
  }

  List<List<double>> _getTemplateSineWaves(List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = <List<double>>[];

    for (int freq in templateFrequencies) {
      List<double> t = List<double>.generate(windowSize, (int i) => i / sampleRate);
      List<double> sineWave = t.map((double ti) => math.sin(2 * math.pi * freq * ti)).toList();

      templateSineWaves.add(sineWave);
    }

    return templateSineWaves;
  }

  double _calcCorrelation(List<double> window, List<List<double>> templateSineWaves) {
    double windowCorrelation = 0.0;

    for (List<double> template in templateSineWaves) {
      double sum = 0.0;
      for (int j = 0; j < windowSize; j++) {
        sum += window[j] * template[j];
      }
      windowCorrelation += sum.abs();
    }

    return windowCorrelation;
  }
}
