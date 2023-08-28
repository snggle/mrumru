import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  group('Test of AudioSettingsModel.maxFrequency', () {
    test('Should return max frequency value (2500) for baseFrequency (1000), frequencyStep (100), bitsPerFrequency (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel(
        baseFrequency: 1000,
        bitDepth: 16,
        bitsPerFrequency: 4,
        channels: 1,
        frequencyStep: 100,
        symbolDuration: 1,
        sampleRate: 7500,
      );

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxFrequency;

      // Assert
      int expectedMaxFrequency = 2500;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });
  });
}