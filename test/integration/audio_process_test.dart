import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generate() and PacketRecognizer.decodedContent()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
      AudioFileSink audioFileSink = AudioFileSink(actualWavFile);

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      // Act (AudioGenerator)
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
      ).generate(actualInputString);

      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Act (PacketRecognizer)
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

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

List<PacketReceivedEvent> _prepareTestEvents(int sampleSize, List<double> wave) {
  List<List<double>> samples = <List<double>>[];
  for (int i = 0; i < wave.length; i += sampleSize) {
    samples.add(wave.sublist(i, min(i + sampleSize, wave.length)));
  }
  List<PacketReceivedEvent> packetReceivedEvent = samples.map(PacketReceivedEvent.new).toList();
  return packetReceivedEvent;
}
