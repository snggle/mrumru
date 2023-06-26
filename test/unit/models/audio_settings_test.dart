import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  group('Test of AudioSettingsModel.calculateMaxFrequency()', () {
    test('Should return max frequency value for defaults audio settings in model', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.calculateMaxFrequency();

      // Assert
      int expectedMaxFrequency = 2500;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });
  });
}
