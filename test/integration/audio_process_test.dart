import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:wav/wav_file.dart';

void main() async {
  group('Tests of AudioGenerator.generateWavFileBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      print(actualAudioSettingsModel.totalFrequencies);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = 'ABCDEFGHIJK';
      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateWavFileBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateWavFileBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      Wav wav = Wav.read(Uint8List.fromList(actualWavFileBytes));
      String actualDecodedWavFileContent = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);

      // Assert
      String expectedDecodedWavFileContent = 'AAABBBCCCDDDEEEFFF';

      expect(actualDecodedWavFileContent, expectedDecodedWavFileContent);
    });
  });
}

