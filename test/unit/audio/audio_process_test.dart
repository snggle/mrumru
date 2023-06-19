import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() async {
  group('Tests of AudioGenerator.generateAudioBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate byte list and correctly decode it', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel(
        baseFrequency: 1000,
        frequencyStep: 100,
        sampleRate: 44100,
        bitDepth: 16,
        channels: 1,
        symbolDuration: 1,
        bitsPerFrequency: 4,
      );

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel);

      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateAudioBytes(actualInputString);

      // Read WAV file
      // Because output of the "generateAudioBytes" method is very large it's not possible to create a mock of it
      // For this reason we are generating bytes using [generateAudioBytes] method
      // and then we are checking if we can decode it using [decodeRecordedAudio] method
      String actualDecodedWavFileContent = await actualAudioDecoder.decodeRecordedAudio(Uint8List.fromList(actualGeneratedWavBytes));

      // Assert
      String expectedDecodedWavFileContent = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      expect(actualDecodedWavFileContent, expectedDecodedWavFileContent);
    });
  });
}