import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/audio/generator/samples_processor.dart';
import 'package:mrumru/src/shared/models/audio_settings_model.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('Test of SamplesProcessor.processSamples()', () {
    test('Should [build wave] for given samples', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      SamplesProcessor actualSampleProcessor = SamplesProcessor();
      List<SampleModel> actualSamples = <SampleModel>[
        SampleModel(
          chunkedFrequencies: const <int>[400, 1400, 2200, 2800, 4200, 4800, 5200, 6200, 7400, 8000, 8400, 9200, 10000, 11400, 11800, 12400],
          audioSettingsModel: actualAudioSettingsModel,
        ),
      ];

      // Act
      List<Float32List> actualWave = <Float32List>[];
      await actualSampleProcessor.processSamples(samplesList: actualSamples, onSampleCreated: actualWave.add);

      // Assert
      List<Float32List> expectedWave = TestUtils.parseFileToFloat32List(File('test/unit/audio/assets/mocked_sample_processor_samples.txt'));

      expect(actualWave, expectedWave);
    });
  });
}
