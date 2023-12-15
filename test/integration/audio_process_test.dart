import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:wav/wav_file.dart';

void main() async {
  group('Tests of AudioGenerator.generateAudioBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);
      AudioDecoder actualAudioDecoder = AudioDecoder(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateAudioBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateAudioBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      Wav wav = Wav.read(Uint8List.fromList(actualWavFileBytes));
      String actualDecodedWavFileContent = await actualAudioDecoder.decodeRecordedAudio(wav.channels.first);

      // Assert
      String expectedDecodedWavFileContent = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      expect(actualDecodedWavFileContent, expectedDecodedWavFileContent);
    });
  });
}
