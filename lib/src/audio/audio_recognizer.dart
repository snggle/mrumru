import 'dart:math' as math;

import 'package:equatable/equatable.dart';

class IndexCorrelation extends Equatable {
  final int index;
  final double correlation;

  const IndexCorrelation({required this.index, required this.correlation});

  @override
  List<Object?> get props => <Object>[index, correlation];
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
    return _adjustWaveLength(wave, firstIndex, lastIndex);
  }

  int _findFirstIndex(List<double> wave) => _findIndex(wave, startFrequencies, isStart: true);

  int _findLastIndex(List<double> wave) => _findIndex(wave, endFrequencies, isStart: false);

  int _findIndex(List<double> wave, List<int> frequencies, {required bool isStart}) {
    List<List<double>> templateSineWaves = _getTemplateSineWaves(frequencies);
    List<IndexCorrelation> correlations = <IndexCorrelation>[];

    int limit = math.min(wave.length - windowSize, maxStartOffset * sampleRate);
    for (int i = 0; i <= limit; i++) {
      int windowStart = isStart ? i : wave.length - windowSize - i;
      List<double> window = wave.sublist(windowStart, windowStart + windowSize);
      double windowCorrelation = _calcCorrelation(window, templateSineWaves);
      correlations.add(IndexCorrelation(index: windowStart, correlation: windowCorrelation));
    }

    return correlations.reduce((IndexCorrelation a, IndexCorrelation b) => a.correlation > b.correlation ? a : b).index + (isStart ? sampleSize : 0);
  }

  List<List<double>> _getTemplateSineWaves(List<int> frequencies) {
    return frequencies.map((int freq) => List<double>.generate(windowSize, (int i) => math.sin(2 * math.pi * freq * i / sampleRate))).toList();
  }

  double _calcCorrelation(List<double> window, List<List<double>> templateSineWaves) {
    return templateSineWaves.fold<double>(0.0, (double total, List<double> template) {
      return total +
          window.asMap().entries.fold<double>(0.0, (double sum, MapEntry<int, double> entry) {
            return sum + (window[entry.key] * template[entry.key]).abs();
          });
    });
  }

  List<double> _adjustWaveLength(List<double> wave, int firstIndex, int lastIndex) {
    List<double> trimmed = wave.sublist(firstIndex, lastIndex);
    int diff = trimmed.length % sampleSize;
    if (diff > sampleSize / 2) {
      return trimmed.sublist(0, trimmed.length - diff);
    }
    return trimmed + List<double>.filled(sampleSize - diff, 0.0);
  }
}
