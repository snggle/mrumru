import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/packet_event.dart';
import 'package:mrumru/src/audio/packet_recognizer.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generateWavFileBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = 'Lorem ipsum dolor sit amet';
      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateWavFileBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateWavFileBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      Wav wav = Wav.read(Uint8List.fromList(actualWavFileBytes));
      List<double> actualWave = wav.channels.first;

      List<List<double>> samples = <List<double>>[];
      for (int i = 0; i < actualWave.length; i += actualAudioSettingsModel.sampleSize) {
        samples.add(actualWave.sublist(i, min(i + actualAudioSettingsModel.sampleSize, actualWave.length)));
      }
      List<ReceivedPacketEvent> actualReceivedPacketEvents = samples.map(ReceivedPacketEvent.new).toList();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      unawaited(actualPacketRecognizer.startDecoding());

      for (ReceivedPacketEvent packets in actualReceivedPacketEvents) {
        actualPacketRecognizer.addPacket(packets);
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <FrameModel>[
          FrameModel(frameIndex: 0, framesCount: 7, rawData: 'Lore', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 1, framesCount: 7, rawData: 'm ip', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 2, framesCount: 7, rawData: 'sum ', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 3, framesCount: 7, rawData: 'dolo', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 4, framesCount: 7, rawData: 'r si', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 5, framesCount: 7, rawData: 't am', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 6, framesCount: 7, rawData: 'et', frameSettings: actualFrameSettingsModel)
        ],
      );

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
