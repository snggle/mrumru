import 'dart:math' as math;

class SignalDetector {
  int detectSignalStartDynamic(List<double> signal, int sampleRate, List<int> templateFreqs, double windowLength, int maxStartOffset) {
    int windowSize = (windowLength * sampleRate).toInt();
    List<List<double>> templateSineWaves = <List<double>>[];

    for (int freq in templateFreqs) {
      List<double> t = List<double>.generate(windowSize, (int i) => i / sampleRate);
      List<double> sineWave = t.map((double ti) => math.sin(2 * math.pi * freq * ti)).toList();
      templateSineWaves.add(sineWave);
    }

    double bestCorrelation = 0.0;
    int bestStart = 0;

    List<double> correlation = List<double>.filled(signal.length - windowSize, 0.0);

    for (int i = 0; i < math.min(signal.length - windowSize, (maxStartOffset * sampleRate).toInt()); i++) {
      List<double> window = signal.sublist(i, i + windowSize);
      double windowCorrelation = 0.0;

      for (List<double> template in templateSineWaves) {
        double sum = 0.0;
        for (int j = 0; j < windowSize; j++) {
          sum += window[j] * template[j];
        }
        windowCorrelation += sum.abs();
      }

      correlation[i] = windowCorrelation;
    }

    int maxCorrelationIdx = correlation.indexWhere((double val) => val == correlation.reduce(math.max));
    double maxCorrelation = correlation[maxCorrelationIdx];

    if (maxCorrelation > bestCorrelation) {
      bestCorrelation = maxCorrelation;
      bestStart = maxCorrelationIdx;
    }

    return bestStart;
  }
}
