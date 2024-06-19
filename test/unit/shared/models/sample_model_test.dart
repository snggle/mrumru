import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('Tests of SampleModel.calcWave()', () {
    test('Should [calculate wave] from given sample', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      List<int> actualChunkedFrequencies = <int>[400, 1400, 2200, 2800, 4200, 4800, 5200, 6200, 7400, 8000, 8400, 9200, 10000, 11400, 11800, 12400];
      SampleModel actualSampleModel = SampleModel(chunkedFrequencies: actualChunkedFrequencies, audioSettingsModel: actualAudioSettingsModel);

      // Act
      List<double> actualWave = actualSampleModel.calcWave();

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/shared/models/assets/mocked_sample_samples_model.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });
  });

  group('Tests of SampleModel.calcBinary()', () {
    test('Should [calculate binary] from given sample', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      SampleModel actualSampleModel = SampleModel(chunkedFrequencies: const <int>[400, 650, 900, 1150], audioSettingsModel: actualAudioSettingsModel);

      // Act
      String actualString = actualSampleModel.calcBinary();

      // Assert
      String expectedString = '00011011';

      expect(actualString, expectedString);
    });
  });

  group('Tests of SampleModel.fromWave()', () {
    test('Should [created sampleModel] from given wave', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      List<double> actualWave = await TestUtils.readAsDoubleFromFile(File('test/unit/shared/models/assets/mocked_sample_samples_model.txt'));

      // Act
      SampleModel actualSampleModel = SampleModel.fromWave(actualWave, actualAudioSettingsModel);

      // Assert
      SampleModel expectedSampleModel = SampleModel(
        chunkedFrequencies: const <int>[400, 600, 950, 1150, 1350, 1400, 1600, 1950, 2150, 2200, 2400, 2750, 2800, 3000, 3200, 3400, 3750, 3950, 4150, 4200, 4400, 4750, 4800, 5150, 5200, 5400, 5600, 5900, 6150, 6200, 6400, 6600, 6950, 7150, 7350, 7400, 7750, 7950, 8000, 8350, 8400, 8600, 8950, 9150, 9200, 9400, 9650, 9950, 10000, 10200, 10400, 10750, 10950, 11150, 11350, 11400, 11750, 11800, 12000, 12350, 12400, 12600, 12800, 13000],
        audioSettingsModel: actualAudioSettingsModel,
      );

      expect(actualSampleModel, expectedSampleModel);
    });
  });
}
