import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/correlation/frequency_correlation_calculator.dart';

void main() {
  group('Test of FrequencyCorrelationCalculator.findBestFrequency()', () {
    test('Should [return frequency index] with [highest correlation] for specified chunk', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(sampleRate: 10000, symbolDuration: 0.05);
      FrequencyCorrelationCalculator actualFrequencyCorrelationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: actualAudioSettingsModel);
      File actualWaveSamplesFile = File('test/unit/audio/correlation/assets/mocked_frequency_correlation_calculator_wave.txt');
      List<double> actualWave = (await actualWaveSamplesFile.readAsString()).split(', ').map(double.parse).toList();
      int actualChunkIndex = 0;

      // Act
      int actualBestIndex = actualFrequencyCorrelationCalculator.findBestFrequency(actualWave, actualChunkIndex);

      // Assert
      int expectedBestIndex = 400;

      expect(actualBestIndex, expectedBestIndex);
    });
  });
}
