import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/correlation/window_correlation_model.dart';

class StartIndexCorrelationCalculator {
  final AudioSettingsModel audioSettingsModel;

  StartIndexCorrelationCalculator({required this.audioSettingsModel});

  int findIndexWithHighestCorrelation(List<double> wave, List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = _createTemplateSineWaves(templateFrequencies);
    List<WindowCorrelationModel> windowsCorrelations = _calculateCorrelations(wave, templateSineWaves);

    WindowCorrelationModel highestWindowCorrelationModel = windowsCorrelations.reduce((WindowCorrelationModel a, WindowCorrelationModel b) {
      return a.correlation > b.correlation ? a : b;
    });
    return highestWindowCorrelationModel.index + audioSettingsModel.sampleSize;
  }

  List<List<double>> _createTemplateSineWaves(List<int> frequencies) {
    return frequencies.map((int frequency) {
      return List<double>.generate(audioSettingsModel.sampleSize, (int i) => math.sin(2 * math.pi * frequency * i / audioSettingsModel.sampleRate)).toList();
    }).toList();
  }

  List<WindowCorrelationModel> _calculateCorrelations(List<double> wave, List<List<double>> templates) {
    List<WindowCorrelationModel> windowCorrelations = <WindowCorrelationModel>[];

    for (int i = 0; i <= wave.length - audioSettingsModel.sampleSize; i += 50) {
      List<double> window = wave.sublist(i, i + audioSettingsModel.sampleSize);
      double correlation = _calculateCorrelation(window, templates);
      windowCorrelations.add(WindowCorrelationModel(index: i, correlation: correlation));
    }

    return windowCorrelations;
  }

  double _calculateCorrelation(List<double> window, List<List<double>> templates) {
    return templates.fold(0.0, (double total, List<double> template) {
      double sum = 0.0;
      for (int j = 0; j < audioSettingsModel.sampleSize; j++) {
        sum += window[j] * template[j];
      }
      return total + sum.abs();
    });
  }
}
