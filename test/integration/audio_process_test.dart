import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_id.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/shared/enums/frame_version_number.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generate() and PacketRecognizer.decodedContent()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 128);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
      AudioFileSink audioFileSink = AudioFileSink(actualWavFile);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
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

      // Assert
      FrameProtocolManager protocolManager = const FrameProtocolManager(
        compressionEnum: CompressionEnum.noCompression,
        encodingEnum: EncodingEnum.defaultMethod,
        protocolTypeEnum: ProtocolTypeEnum.rawDataTransfer,
        versionNumberEnum: VersionNumberEnum.firstDefault,
      );

      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <FrameModel>[
          FrameModel(frameIndex: 0, framesCount: 20, rawData: '1234', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 1, framesCount: 20, rawData: '5678', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 2, framesCount: 20, rawData: '9:;<', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 3, framesCount: 20, rawData: '=>?@', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 4, framesCount: 20, rawData: 'ABCD', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 5, framesCount: 20, rawData: 'EFGH', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 6, framesCount: 20, rawData: 'IJKL', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 7, framesCount: 20, rawData: 'MNOP', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 8, framesCount: 20, rawData: 'QRST', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 9, framesCount: 20, rawData: 'UVWX', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 10, framesCount: 20, rawData: 'YZ[]', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 11, framesCount: 20, rawData: '^_`a', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 12, framesCount: 20, rawData: 'bcde', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 13, framesCount: 20, rawData: 'fghi', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 14, framesCount: 20, rawData: 'jklm', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 15, framesCount: 20, rawData: 'nopq', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 16, framesCount: 20, rawData: 'rstu', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 17, framesCount: 20, rawData: 'vwxy', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 18, framesCount: 20, rawData: 'z{|}', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2),
          FrameModel(frameIndex: 19, framesCount: 20, rawData: '~', protocolManager: protocolManager, frameLength: 2, compositeChecksum: 2)
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
