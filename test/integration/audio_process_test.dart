import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() async {
  group('Tests of AudioGenerator.generateAudioBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate and correctly decode .WAV file', () async {
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

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateAudioBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateAudioBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      List<int> actualWavFileBytes = await actualWavFile.readAsBytes();
      String actualDecodedWavFileContent = await actualAudioDecoder.decodeRecordedAudio(Uint8List.fromList(actualWavFileBytes));

      // Assert
      String expectedDecodedWavFileContent = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      expect(actualDecodedWavFileContent, expectedDecodedWavFileContent);
    });
  });
}