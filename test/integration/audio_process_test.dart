import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generateWavFileBytes() and PacketRecognizer.decodedContent', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>';
      File file = File(actualWavFile.path);
      IAudioSink fileAudioSink = FileAudioSink(file);
      AudioEmitterNotifier? audioEmitterNotifier;

      AudioEmitter audioEmitter = AudioEmitter(
        audioSink: fileAudioSink,
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        audioEmitterNotifier: audioEmitterNotifier,
      )..play(actualInputString);

      await Future<void>.delayed(const Duration(seconds: 2));

      await fileAudioSink.finish();
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      List<double> actualWave = Wav.read(Uint8List.fromList(actualWavFileBytes)).channels.first;
      List<ReceivedPacketEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      final FrameModelDecoder frameModelDecoder = FrameModelDecoder(
        framesSettingsModel: actualFrameSettingsModel,
        onFirstFrameDecoded: (_) {
          print('First frame decoded');
        },
        onLastFrameDecoded: (_) {
          print('Last frame decoded');
        },
        onFrameDecoded: (_) {
          print('Frame decoded');
        },
      );

      final PacketRecognizer packetRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: () {
          print('Decoding completed');
        },
        onFrequenciesDecoded: (List<DecodedFrequencyModel> frequencies) {
          print('Frequencies decoded: ${frequencies.length}');
          final List<String> binaries = frequencies.map((DecodedFrequencyModel frequency) => frequency.calcBinary(actualAudioSettingsModel)).toList();
          frameModelDecoder.addBinaries(binaries);
        },
      );

      unawaited(packetRecognizer.start());

      for (ReceivedPacketEvent actualTestEvent in testEvents) {
        await packetRecognizer.addPacket(actualTestEvent.packet);
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }

      FrameCollectionModel actualFrameCollectionModel = frameModelDecoder.decodedContent;

      await packetRecognizer.stop();

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <FrameModel>[
          FrameModel(frameIndex: 0, framesCount: 4, rawData: '1234', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 1, framesCount: 4, rawData: '5678', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 2, framesCount: 4, rawData: '9:;<', frameSettings: actualFrameSettingsModel),
          FrameModel(frameIndex: 3, framesCount: 4, rawData: '=>', frameSettings: actualFrameSettingsModel),
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