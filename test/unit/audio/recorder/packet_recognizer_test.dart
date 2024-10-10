import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

import '../../../utils/test_utils.dart';

void main() async {
  group('Test of PacketRecognizer', () {
    test('Should [return FrameCollectionModel] from given wave (chunksCount == 1)', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrame frame) {},
      );

      List<double> actualWave = await TestUtils.readAsDoubleFromFile(
        File('test/unit/audio/assets/mocked_audio_wave_chunks_count_1.txt'),
      );

      // Act
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <ABaseFrame>[
          MetadataFrame(
              frameIndex: Uint16.fromInt(0),
              frameLength: Uint16.fromInt(8),
              framesCount: Uint16.fromInt(1),
              frameProtocolID: Uint32FrameProtocolID.fromValues(
                  frameCompressionType: FrameCompressionType.noCompression,
                  frameEncodingType: FrameEncodingType.defaultMethod,
                  frameProtocolType: FrameProtocolType.rawDataTransfer,
                  frameVersionNumber: FrameVersionNumber.firstDefault),
              sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
              compositeChecksum: Uint32(Uint8List.fromList(<int>[11, 139, 0, 154])),
              data: UintDynamic(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64),
              frameChecksum: Uint16(Uint8List.fromList(<int>[164, 73]))),
          DataFrame(
              frameIndex: Uint16.fromInt(1),
              frameLength: Uint16(Uint8List.fromList(<int>[0, 8])),
              data: UintDynamic.fromBytes(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64).value,
              frameChecksum: Uint16(Uint8List.fromList(<int>[33, 217]))),
        ],
      );
      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from given wave (chunksCount == 2)', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrame frameModel) {},
      );
      List<double> actualWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_2.txt'));

      // Act
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <ABaseFrame>[
          MetadataFrame(
              frameIndex: Uint16.fromInt(0),
              frameLength: Uint16.fromInt(8),
              framesCount: Uint16.fromInt(1),
              frameProtocolID: Uint32FrameProtocolID.fromValues(
                  frameCompressionType: FrameCompressionType.noCompression,
                  frameEncodingType: FrameEncodingType.defaultMethod,
                  frameProtocolType: FrameProtocolType.rawDataTransfer,
                  frameVersionNumber: FrameVersionNumber.firstDefault),
              sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
              compositeChecksum: Uint32(Uint8List.fromList(<int>[11, 139, 0, 154])),
              data: UintDynamic(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64),
              frameChecksum: Uint16(Uint8List.fromList(<int>[164, 73]))),
          DataFrame(
              frameIndex: Uint16.fromInt(1),
              frameLength: Uint16(Uint8List.fromList(<int>[0, 8])),
              data: UintDynamic.fromBytes(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64).value,
              frameChecksum: Uint16(Uint8List.fromList(<int>[33, 217]))),
        ],
      );
      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from given wave (chunksCount == 4)', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrame frameModel) {},
      );
      List<double> actualWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_4.txt'));

      // Act
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <ABaseFrame>[
          MetadataFrame(
              frameIndex: Uint16.fromInt(0),
              frameLength: Uint16.fromInt(0),
              framesCount: Uint16.fromInt(1),
              frameProtocolID: Uint32FrameProtocolID.fromValues(
                  frameCompressionType: FrameCompressionType.noCompression,
                  frameEncodingType: FrameEncodingType.defaultMethod,
                  frameProtocolType: FrameProtocolType.rawDataTransfer,
                  frameVersionNumber: FrameVersionNumber.firstDefault),
              sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
              compositeChecksum: Uint32(Uint8List.fromList(<int>[11, 139, 0, 154])),
              data: UintDynamic(Uint8List.fromList(<int>[]), 0),
              frameChecksum: Uint16(Uint8List.fromList(<int>[143, 128]))),
          DataFrame(
              frameIndex: Uint16.fromInt(1),
              frameLength: Uint16(Uint8List.fromList(<int>[0, 8])),
              data: UintDynamic.fromBytes(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64).value,
              frameChecksum: Uint16(Uint8List.fromList(<int>[33, 217]))),
        ],
      );

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from given wave (chunksCount == 8)', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrame frameModel) {},
      );
      List<double> actualWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_8.txt'));

      // Act
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
        <ABaseFrame>[
          MetadataFrame(
              frameIndex: Uint16.fromInt(0),
              frameLength: Uint16.fromInt(0),
              framesCount: Uint16.fromInt(1),
              frameProtocolID: Uint32FrameProtocolID.fromValues(
                  frameCompressionType: FrameCompressionType.noCompression,
                  frameEncodingType: FrameEncodingType.defaultMethod,
                  frameProtocolType: FrameProtocolType.rawDataTransfer,
                  frameVersionNumber: FrameVersionNumber.firstDefault),
              sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
              compositeChecksum: Uint32(Uint8List.fromList(<int>[11, 139, 0, 154])),
              data: UintDynamic(Uint8List.fromList(<int>[]), 0),
              frameChecksum: Uint16(Uint8List.fromList(<int>[143, 128]))),
          DataFrame(
              frameIndex: Uint16.fromInt(1),
              frameLength: Uint16(Uint8List.fromList(<int>[0, 8])),
              data: UintDynamic.fromBytes(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56]), 64).value,
              frameChecksum: Uint16(Uint8List.fromList(<int>[33, 217]))),
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
