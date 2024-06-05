import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/correlation/start_index_correlation_calculator.dart';

void main() {
  group('Test of StartIndexCorrelationCalculator.findIndexWithHighestCorrelation()', () {
    test('Should [return first index] of sample with [highest correlation] with given frequencies', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(
        symbolDuration: 0.05,
        sampleRate: 10000,
      );
      StartIndexCorrelationCalculator actualStartIndexCorrelationCalculator = StartIndexCorrelationCalculator(audioSettingsModel: actualAudioSettingsModel);
      File actualWaveSamplesFile = File('test/unit/audio/recorder/correlation/assets/mocked_start_index_correlation_calculator_wave.txt');
      List<double> actualWave = (await actualWaveSamplesFile.readAsString()).split(', ').map(double.parse).toList();

      // Act
      int actualBestIndex = actualStartIndexCorrelationCalculator.findIndexWithHighestCorrelation(actualWave, actualAudioSettingsModel.startFrequencies);

      // Assert
      int expectedBestIndex = 500;

      expect(actualBestIndex, expectedBestIndex);
    });
  });
}
