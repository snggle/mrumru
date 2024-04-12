import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/packet_event_queue/received_packet_event.dart';
import 'package:mrumru/src/recorder/packet_recognizer.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generateWavFileBytes() and PacketRecognizer.decodedContent', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      SampleGenerator actualAudioGenerator = SampleGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateWavFileBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateWavFileBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      List<double> actualWave = Wav.read(Uint8List.fromList(actualWavFileBytes)).channels.first;
      List<ReceivedPacketEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (ReceivedPacketEvent actualTestEvent in testEvents) {
        actualPacketRecognizer.addPacket(actualTestEvent);
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <FrameModel>[
          FrameModel(frameIndex: 0, framesCount: 20, rawData: '1234', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 1, framesCount: 20, rawData: '5678', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 2, framesCount: 20, rawData: '9:;<', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 3, framesCount: 20, rawData: '=>?@', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 4, framesCount: 20, rawData: 'ABCD', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 5, framesCount: 20, rawData: 'EFGH', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 6, framesCount: 20, rawData: 'IJKL', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 7, framesCount: 20, rawData: 'MNOP', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 8, framesCount: 20, rawData: 'QRST', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 9, framesCount: 20, rawData: 'UVWX', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 10, framesCount: 20, rawData: 'YZ[]', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 11, framesCount: 20, rawData: '^_`a', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 12, framesCount: 20, rawData: 'bcde', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 13, framesCount: 20, rawData: 'fghi', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 14, framesCount: 20, rawData: 'jklm', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 15, framesCount: 20, rawData: 'nopq', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 16, framesCount: 20, rawData: 'rstu', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 17, framesCount: 20, rawData: 'vwxy', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 18, framesCount: 20, rawData: 'z{|}', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 19, framesCount: 20, rawData: '~', frameSettings: actualFrameSettingsModel)
        ],
      );

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}

List<ReceivedPacketEvent> _prepareTestEvents(int sampleSize, List<double> wave) {
  List<List<double>> samples = <List<double>>[];
  for (int i = 0; i < wave.length; i += sampleSize) {
    samples.add(wave.sublist(i, min(i + sampleSize, wave.length)));
  }
  List<ReceivedPacketEvent> receivedPacketEvents = samples.map(ReceivedPacketEvent.new).toList();
  return receivedPacketEvents;
}