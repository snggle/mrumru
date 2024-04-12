import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';

class IndexCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  IndexCorrelationCalculator({required this.audioSettingsModel});

  int findBestIndex(List<double> wave, List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = _createTemplateSineWaves(templateFrequencies);
    List<WindowCorrelationModel> windowCorrelations = _calculateWindowCorrelations(wave, templateSineWaves);

    WindowCorrelationModel maxWindowCorrelationModel = _findMaxCorrelation(windowCorrelations);
    return maxWindowCorrelationModel.index + audioSettingsModel.sampleSize;
  }

  List<List<double>> _createTemplateSineWaves(List<int> frequencies) {
    return frequencies.map((int freq) {
      return List<double>.generate(audioSettingsModel.sampleSize, (int i) => math.sin(2 * math.pi * freq * i / audioSettingsModel.sampleRate)).toList();
    }).toList();
  }

  List<WindowCorrelationModel> _calculateWindowCorrelations(List<double> wave, List<List<double>> templates) {
    List<WindowCorrelationModel> windowCorrelations = <WindowCorrelationModel>[];

    for (int i = 0; i <= wave.length - audioSettingsModel.sampleSize; i += 50) {
      List<double> window = wave.sublist(i, i + audioSettingsModel.sampleSize);
      double correlation = _calculateWindowCorrelation(window, templates);
      windowCorrelations.add(WindowCorrelationModel(index: i, correlation: correlation));
    }

    return windowCorrelations;
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

  WindowCorrelationModel _findMaxCorrelation(List<WindowCorrelationModel> windowCorrelations) {
    return windowCorrelations.reduce((WindowCorrelationModel a, WindowCorrelationModel b) => a.correlation > b.correlation ? a : b);
  }
}
