import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/correlation/chunk_frequency_correlation_calculator.dart';

void main() {
  group('Test of ChunkFrequencyCorrelationCalculator.findFrequencyWithHighestCorrelation()', () {
    test('Should [return frequency index] with [highest correlation] for specified chunk', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(sampleRate: 10000, symbolDuration: 0.05);
      ChunkFrequencyCorrelationCalculator actualChunkFrequencyCorrelationCalculator =
          ChunkFrequencyCorrelationCalculator(audioSettingsModel: actualAudioSettingsModel);
      File actualWaveSamplesFile = File('test/unit/audio/recorder/correlation/assets/mocked_chunk_frequency_correlation_calculator_wave.txt');
      List<double> actualWave = (await actualWaveSamplesFile.readAsString()).split(', ').map(double.parse).toList();
      int actualChunkIndex = 0;

      // Act
      int actualBestIndex = actualChunkFrequencyCorrelationCalculator.findFrequencyWithHighestCorrelation(actualWave, actualChunkIndex);

      // Assert
      int expectedBestIndex = 400;

      expect(actualBestIndex, expectedBestIndex);
    });
  });
}
