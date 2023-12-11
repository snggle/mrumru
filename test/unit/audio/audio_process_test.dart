import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() async {
  group('Tests of AudioGenerator.generateSamples() and AudioDecoder.decodeRecordedAudio()', () {
    String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
    String expectedDecodedSamples = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

    test('Should generate byte list and correctly decode it [chunksCount = 1]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualSamples = actualAudioGenerator.generateSamples(actualInputString);

      // Because output of the "generateSamples" method is very large it's not possible to create a mock of it
      // For this reason we are generating bytes using [generateSamples] method
      // and then we are checking if we can decode it using [decodeRecordedAudio] method
      String actualDecodedSamples = actualAudioDecoder.decodeRecordedAudio(actualSamples);

      // Assert
      expect(actualDecodedSamples, expectedDecodedSamples);
    });

    test('Should generate byte list and correctly decode it [chunksCount = 2]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualSamples = actualAudioGenerator.generateSamples(actualInputString);

      // Because output of the "generateSamples" method is very large it's not possible to create a mock of it
      // For this reason we are generating bytes using [generateSamples] method
      // and then we are checking if we can decode it using [decodeRecordedAudio] method
      String actualDecodedSamples = actualAudioDecoder.decodeRecordedAudio(actualSamples);

      // Assert
      expect(actualDecodedSamples, expectedDecodedSamples);
    });

    test('Should generate byte list and correctly decode it [chunksCount = 4]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualSamples = actualAudioGenerator.generateSamples(actualInputString);

      // Because output of the "generateSamples" method is very large it's not possible to create a mock of it
      // For this reason we are generating bytes using [generateSamples] method
      // and then we are checking if we can decode it using [decodeRecordedAudio] method
      String actualDecodedSamples = actualAudioDecoder.decodeRecordedAudio(actualSamples);

      // Assert
      expect(actualDecodedSamples, expectedDecodedSamples);
    });

    test('Should generate byte list and correctly decode it [chunksCount = 8]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualSamples = actualAudioGenerator.generateSamples(actualInputString);

      // Because output of the "generateSamples" method is very large it's not possible to create a mock of it
      // For this reason we are generating bytes using [generateSamples] method
      // and then we are checking if we can decode it using [decodeRecordedAudio] method
      String actualDecodedSamples = actualAudioDecoder.decodeRecordedAudio(actualSamples);

      // Assert
      expect(actualDecodedSamples, expectedDecodedSamples);
    });
  });
}
