import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/audio/generator/samples_generator_thread.dart';
import 'package:mrumru/src/shared/models/audio_settings_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('Test of SamplesGeneratorThread.parseFrequenciesToSamples()', () {
    test('Should [parse samples] for given frequencies', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      SamplesGeneratorThread actualSamplesGenerator = SamplesGeneratorThread(actualAudioSettingsModel);
      List<List<int>> actualFrequencies = <List<int>>[
        <int>[440]
      ];

      // Act
      List<Float32List> actualSamples = <Float32List>[];
      await for (Float32List actualSample in actualSamplesGenerator.parseFrequenciesToSamples(actualFrequencies)) {
        actualSamples.add(actualSample);
      }

      // Assert
      File expectedSamplesFile = File('test/unit/audio/generator/assets/mocked_sample_generator_samples.txt');
      List<Float32List> expectedSamples = TestUtils.parseFileToFloat32List(expectedSamplesFile);

      expect(actualSamples, expectedSamples);
    });
  });
}
