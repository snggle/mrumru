import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/packet_event_queue/received_packet_event.dart';
import 'package:mrumru/src/recorder/packet_recognizer/packet_recognizer.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';

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

      SampleGenerator actualAudioGenerator = SampleGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<ReceivedPacketEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.start());

      for (ReceivedPacketEvent packets in actualTestEvents) {
        actualPacketRecognizer.addPacket(packets);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stop();

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

      SampleGenerator actualAudioGenerator = SampleGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<ReceivedPacketEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.start());

      for (ReceivedPacketEvent packets in actualTestEvents) {
        actualPacketRecognizer.addPacket(packets);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stop();

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

      SampleGenerator actualAudioGenerator = SampleGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<ReceivedPacketEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.start());

      for (ReceivedPacketEvent packets in actualTestEvents) {
        actualPacketRecognizer.addPacket(packets);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stop();

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

      SampleGenerator actualAudioGenerator = SampleGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      // Act
      List<double> actualWave = actualAudioGenerator.generateSamples(actualInputString);

      List<ReceivedPacketEvent> actualTestEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.start());

      for (ReceivedPacketEvent packets in actualTestEvents) {
        actualPacketRecognizer.addPacket(packets);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;

      await actualPacketRecognizer.stop();

      // Assert
      String actualDecodedString = actualFrameCollectionModel.mergedRawData;

      expect(actualDecodedString, expectedDecodedSamples);
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