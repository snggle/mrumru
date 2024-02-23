import 'dart:io';
import 'dart:math';

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/audio_recognizer.dart';
import 'package:mrumru/src/audio/fsk/fsk_decoder.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/math_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wav/wav.dart';

class AudioDecoder {
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;
  final FskDecoder fskDecoder;
  final FrameModelDecoder frameModelDecoder;

  AudioDecoder({
    required this.audioSettingsModel,
    required this.frameSettingsModel,
  })  : fskDecoder = FskDecoder(audioSettingsModel),
        frameModelDecoder = FrameModelDecoder(framesSettingsModel: frameSettingsModel);

  String decodeRecordedAudio(List<double> waveBytes) {
    String signature = DateTime.now().millisecondsSinceEpoch.toString();
    // saveFile(waveBytes, '${signature}full');

    // List<double> trimmedWave = audioRecognizer.trim(waveBytes);
    // saveFile(trimmedWave, '${signature}trimmed');

    List<int> detectedFrequencies = _parseWaveBytesToFrequencies(waveBytes);
    print(detectedFrequencies);
    String binaryData = fskDecoder.decodeFrequenciesToBinary(detectedFrequencies);
    FrameCollectionModel frameCollectionModel = frameModelDecoder.decodeBinaryData(binaryData);

    return frameCollectionModel.mergedRawData;
  }

  List<int> _parseWaveBytesToFrequencies(List<double> waveBytes) {
    int expectedSampleSize = audioSettingsModel.sampleSize;
    int chunksCount = audioSettingsModel.chunksCount;

    int samplesCount = waveBytes.length ~/ expectedSampleSize;
    int totalFrequenciesCount = samplesCount * chunksCount;

    print('Samples count: $samplesCount');
    print('Total frequencies count: $totalFrequenciesCount');
    List<int> detectedFrequencies = List<int>.filled(totalFrequenciesCount, 0);

    for (int sampleIndex = 0; sampleIndex < samplesCount; sampleIndex++) {
      List<double> chunkFrequencySample = _extractFrequencySample(waveBytes, sampleIndex);

      for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
        int highestFrequency = _findHighestFrequency(chunkFrequencySample, chunkIndex);
        int frequencyIndex = sampleIndex + (samplesCount * chunkIndex);
        detectedFrequencies[frequencyIndex] = highestFrequency;
      }
    }

    detectedFrequencies = detectedFrequencies;
    return detectedFrequencies;
  }

  Future<void> saveFile(List<double> wave, String name) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String path = tempDir.path;
    // // // String path = './test';
    List<Float64List> channels = <Float64List>[Float64List.fromList(wave)];
    Uint8List uint8list = Wav(channels, audioSettingsModel.sampleRate, WavFormat.float32).write();
    File file = await File('${path}/snggle/$name.wav').create(recursive: true);
    await file.writeAsBytes(uint8list);
    print('File $name saved to: ${file.path}');
  }

  List<double> _extractFrequencySample(List<double> waveBytes, int sampleIndex) {
    int expectedSampleSize = audioSettingsModel.sampleSize;
    int startSampleIndex = sampleIndex * expectedSampleSize;
    int endSampleIndex = startSampleIndex + expectedSampleSize;
    return waveBytes.sublist(startSampleIndex, endSampleIndex);
  }

  int _findHighestFrequency(List<double> chunkFrequencySample, int chunkIndex) {
    List<FrequencyCorrelationModel> frequencyCorrelations = _calculateFrequencyCorrelations(chunkFrequencySample, chunkIndex);
    int highestFrequency =
        frequencyCorrelations.reduce((FrequencyCorrelationModel a, FrequencyCorrelationModel b) => a.correlation > b.correlation ? a : b).frequency;
    return highestFrequency;
  }

  List<FrequencyCorrelationModel> _calculateFrequencyCorrelations(List<double> chunkFrequencySample, int chunkIndex) {
    List<FrequencyCorrelationModel> frequencyCorrelations = <FrequencyCorrelationModel>[];

    for (int possibleFrequency in audioSettingsModel.possibleFrequencies) {
      int frequencyRange = audioSettingsModel.frequencyRange;
      int chunkFrequency = possibleFrequency + chunkIndex * frequencyRange;
      double correlation = _calculateAmplitude(chunkFrequencySample, chunkFrequency);
      frequencyCorrelations.add(FrequencyCorrelationModel(correlation: correlation, frequency: chunkFrequency));
    }

    return frequencyCorrelations;
  }

  double _calculateAmplitude(List<double> samples, int frequency) {
    int sampleRate = audioSettingsModel.sampleRate;
    int sampleCount = samples.length;
    double angleStep = (2 * pi * frequency) / sampleRate;
    double sumCos = 0;
    double sumSin = 0;

    for (int i = 0; i < sampleCount; i++) {
      double sampleValue = samples[i] / audioSettingsModel.amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / sampleCount - 0.5);

      sumCos += sampleValue * cos(i * angleStep) * sincValue;
      sumSin += sampleValue * sin(i * angleStep) * sincValue;
    }

    double calculatedAmplitude = 2 * sqrt(sumCos * sumCos + sumSin * sumSin) / sampleCount;
    return calculatedAmplitude;
  }
}
