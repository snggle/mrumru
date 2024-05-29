import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/decoded_frequency_model.dart';

void main() {
  group('Test of DecodedFrequencyModel.calcBinary()', () {
    AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith();
    test('Should [return calculated binary] from given [chunk frequency = 1000] on specified [chunkIndex = 0]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 1000, chunkIndex: 0);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 2200] on specified [chunkIndex = 1]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 2200, chunkIndex: 1);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 3400] on specified [chunkIndex = 2]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 3400, chunkIndex: 2);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 4600] on specified [chunkIndex = 3]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 4600, chunkIndex: 3);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 5800] on specified [chunkIndex = 4]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 5800, chunkIndex: 4);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 7000] on specified [chunkIndex = 5]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 7000, chunkIndex: 5);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 8200] on specified [chunkIndex = 6]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 8200, chunkIndex: 6);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });

    test('Should [return calculated binary] from given [chunk frequency = 9400] on specified [chunkIndex = 7]', () {
      // Arrange
      DecodedFrequencyModel actualDecodedFrequencyModel = const DecodedFrequencyModel(chunkFrequency: 9400, chunkIndex: 7);

      // Act
      String actualCalculatedBinary = actualDecodedFrequencyModel.calcBinary(actualAudioSettingsModel);

      // Assert
      String expectedCalculatedBinary = '11';

      expect(actualCalculatedBinary, expectedCalculatedBinary);
    });
  });
}
