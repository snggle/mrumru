import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

void main() async {
  group('Tests of AudioGenerator.generateSamples() and PackageRecognizer decoding process', () {
    String actualInputString = 'Lorem ipsum dolor sit amet';
    String expectedDecodedSamples = 'Lorem ipsum dolor sit amet';

    test('Should [generate samples] and correctly decode them if [chunksCount == 1]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<PacketReceivedEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in actualTestEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      String actualDecodedString = actualFrameCollectionModel.mergedRawData;

      expect(actualDecodedString, expectedDecodedSamples);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 2]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<PacketReceivedEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in actualTestEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      String actualDecodedString = actualFrameCollectionModel.mergedRawData;

      expect(actualDecodedString, expectedDecodedSamples);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 4]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<PacketReceivedEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in actualTestEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      String actualDecodedString = actualFrameCollectionModel.mergedRawData;

      expect(actualDecodedString, expectedDecodedSamples);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 8]', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        frameSettingsModel: actualFrameSettingsModel,
        onDecodingCompleted: () {},
        onFrameDecoded: (FrameModel frameModel) {},
      );

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<PacketReceivedEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in actualTestEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stopRecording();

      // Assert
      String actualDecodedString = actualFrameCollectionModel.mergedRawData;

      expect(actualDecodedString, expectedDecodedSamples);
    });
  });
}

List<PacketReceivedEvent> _prepareTestEvents(int sampleSize, List<double> wave) {
  List<List<double>> samples = <List<double>>[];
  for (int i = 0; i < wave.length; i += sampleSize) {
    samples.add(wave.sublist(i, min(i + sampleSize, wave.length)));
  }
  List<PacketReceivedEvent> packetReceivedEvents = samples.map(PacketReceivedEvent.new).toList();
  return packetReceivedEvents;
}
