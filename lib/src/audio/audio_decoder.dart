import 'dart:math';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/fsk/fsk_decoder.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/math_utils.dart';

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

  Future<String> decodeRecordedAudio(List<double> waveBytes) async {
    List<int> detectedFrequencies = _parseWaveBytesToFrequencies(waveBytes);
    String binaryData = fskDecoder.decodeFrequenciesToBinary(detectedFrequencies);
    FrameCollectionModel frameCollectionModel = frameModelDecoder.decodeBinaryData(binaryData);

    return frameCollectionModel.mergedRawData;
  }

  List<int> _parseWaveBytesToFrequencies(List<double> waveBytes) {
    int expectedSampleSize = audioSettingsModel.sampleSize;
    int chunksCount = audioSettingsModel.chunksCount;

    int samplesCount = waveBytes.length ~/ expectedSampleSize;
    int totalFrequenciesCount = samplesCount * chunksCount;
    List<int> detectedFrequencies = List<int>.filled(totalFrequenciesCount, 0);

    for (int sampleIndex = 0; sampleIndex < samplesCount; sampleIndex++) {
      List<double> chunkFrequencySample = _extractFrequencySample(waveBytes, sampleIndex);

      for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
        int highestFrequency = _findHighestFrequency(chunkFrequencySample, chunkIndex);
        int frequencyIndex = sampleIndex + (samplesCount * chunkIndex);
        detectedFrequencies[frequencyIndex] = highestFrequency;
      }
    }

    return detectedFrequencies;
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
