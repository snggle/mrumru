import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/correlation/chunk_frequency_correlation_calculator.dart';

import '../../../../utils/test_utils.dart';

void main() {
  group('Test of ChunkFrequencyCorrelationCalculator.findFrequencyWithHighestCorrelation()', () {
    test('Should [return frequency index] with [highest correlation] for specified chunk', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel =
          AudioSettingsModel.withDefaults().copyWith(sampleRate: 10000, symbolDuration: const Duration(milliseconds: 50));
      ChunkFrequencyCorrelationCalculator actualChunkFrequencyCorrelationCalculator =
          ChunkFrequencyCorrelationCalculator(audioSettingsModel: actualAudioSettingsModel);
      File actualWaveSamplesFile = File('test/unit/audio/recorder/correlation/assets/mocked_chunk_frequency_correlation_calculator_wave.txt');
      List<double> actualWave = await TestUtils.readAsDoubleFromFile(actualWaveSamplesFile);
      int actualChunkIndex = 0;

      // Act
      int actualChunkFrequency = actualChunkFrequencyCorrelationCalculator.findFrequencyWithHighestCorrelation(actualWave, actualChunkIndex);

      // Assert
      int expectedChunkFrequency = 400;

      expect(actualChunkFrequency, expectedChunkFrequency);
    });
  });
}
