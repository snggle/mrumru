import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';

import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generate() and PacketRecognizer.decodedContent()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16, maxSkippedSamples: 1);
      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      Uint8List actualInputBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');
      AudioFileSink audioFileSink = AudioFileSink(actualWavFile);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrame frameModel) {},
      );

      // Act (AudioGenerator)
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: actualAudioSettingsModel,
      ).generate(actualInputBytes);

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

      // @formatter:off
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrame>[
        MetadataFrame(
            frameLength: Uint16(Uint8List.fromList(<int>[0, 0])),
            frameIndex: Uint16(Uint8List.fromList(<int>[0, 0])),
            framesCount: Uint16(Uint8List.fromList(<int>[0, 3])),
            frameProtocolID: FrameProtocolID(frameCompressionType: Uint8(Uint8List.fromList(<int>[0])),
                frameEncodingType: Uint8(Uint8List.fromList(<int>[0])),
                frameProtocolType: Uint8(Uint8List.fromList(<int>[0])),
                frameVersionNumber: Uint8(Uint8List.fromList(<int>[1]))),
            sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
            compositeChecksum: Uint32(Uint8List.fromList(<int>[214, 197, 141, 48])),
            data: UintDynamic(Uint8List.fromList(<int>[]), 0),
            frameChecksum: Uint16(Uint8List.fromList(<int>[77, 19]))),
        DataFrame(
            frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
            frameLength: Uint16(Uint8List.fromList(<int>[0, 32])),
            data: UintDynamic(Uint8List.fromList(
                <int>[49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80]), 256),
            frameChecksum: Uint16(Uint8List.fromList(<int>[224, 117]))),
        DataFrame(
            frameIndex:Uint16(Uint8List.fromList(<int>[0, 2])),
            frameLength: Uint16(Uint8List.fromList(<int>[0, 32])),
            data: UintDynamic(Uint8List.fromList(
                <int>[81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113]), 256),
            frameChecksum: Uint16(Uint8List.fromList(<int>[127, 229]))),
        DataFrame(
            frameIndex:Uint16(Uint8List.fromList(<int>[0, 3])),
            frameLength: Uint16(Uint8List.fromList(<int>[0, 13])),
            data: UintDynamic(Uint8List.fromList(<int>[114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126]), 104),
            frameChecksum: Uint16(Uint8List.fromList(<int>[70, 194])))
      ]);
      // @formatter:on

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
