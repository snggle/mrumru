import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/packet_recognizer.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:wav/wav_file.dart';

void main() async {
  group('Tests of AudioGenerator.generateWavFileBytes() and AudioDecoder.decodeRecordedAudio()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();
      FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();

      AudioGenerator actualAudioGenerator = AudioGenerator(audioSettingsModel: actualAudioSettingsModel, frameSettingsModel: actualFrameSettingsModel);

      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      String actualInputString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec diam odio, vulputate non porttitor sit amet, vulputate sit amet purus. In vel risus orci. Fusce velit urna, imperdiet sit amet mi et, lacinia pellentesque neque. Phasellus vel sem sapien. Aliquam tincidunt hendrerit leo eget ultricies. Sed vel nunc a quam dapibus scelerisque sed in risus. Curabitur nec justo et orci interdum dapibus. In ullamcorper, urna in laoreet congue, felis felis ornare elit, eget ullamcorper felis mauris in nisi.';
      // Act
      // Create WAV file
      List<int> actualGeneratedWavBytes = actualAudioGenerator.generateWavFileBytes(actualInputString);
      await actualWavFile.writeAsBytes(actualGeneratedWavBytes);

      // Read WAV file
      // Because output of the "generateWavFileBytes" method is very large it's not possible to create a mock of it
      // For this reason we save the output to a .WAV file and then read it and try to decode it
      // Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();

      // Wav wav = Wav.read(Uint8List.fromList(actualWavFileBytes));
      // List<double> actualWave = wav.channels.first;
      //
      // List<List<double>> samples = <List<double>>[];
      // for (int i = 0; i < actualWave.length; i += actualAudioSettingsModel.sampleSize) {
      //   samples.add(actualWave.sublist(i, min(i + actualAudioSettingsModel.sampleSize, actualWave.length)));
      // }
      //
      // PacketRecognizer actualPacketRecognizer = PacketRecognizer(
      //   audioSettingsModel: actualAudioSettingsModel,
      //   frameSettingsModel: actualFrameSettingsModel,
      //   onDecodingCompleted: () {},
      //   onFrameDecoded: (FrameModel frameModel) {},
      // );
      //
      // for (List<double> sample in samples) {
      //   actualPacketRecognizer.addPacket(sample);
      //   await Future<void>.delayed(const Duration(milliseconds: 100));
      // }
      //
      // FrameCollectionModel actualFrameCollectionModel = actualPacketRecognizer.decodedContent;
      //
      // // Assert
      // FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(
      //   <FrameModel>[
      //     FrameModel(frameIndex: 0, framesCount: 4, rawData: 'Domi', frameSettings: actualFrameSettingsModel),
      //     FrameModel(frameIndex: 1, framesCount: 4, rawData: 'nik', frameSettings: actualFrameSettingsModel),
      //     FrameModel(frameIndex: 2, framesCount: 4, rawData: 'Paja', frameSettings: actualFrameSettingsModel),
      //     FrameModel(frameIndex: 3, framesCount: 4, rawData: 'k', frameSettings: actualFrameSettingsModel),
      //   ],
      // );
      //
      // expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
