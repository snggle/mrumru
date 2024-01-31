import 'dart:math' as math;

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

  int detectSignalStartDynamic(List<double> signal, int sampleRate, List<double> templateFreqs, double windowLength, int maxStartOffset) {
    int windowSize = (windowLength * sampleRate).toInt();
    List<List<double>> templateSineWaves = <List<double>>[];

    for (double freq in templateFreqs) {
      List<double> t = List<double>.generate(windowSize, (int i) => i / sampleRate);
      List<double> sineWave = t.map((double ti) => math.sin(2 * math.pi * freq * ti)).toList();
      templateSineWaves.add(sineWave);
    }

    double bestCorrelation = 0.0;
    int bestStart = 0;

    List<double> correlation = List<double>.filled(signal.length - windowSize, 0.0);

    for (int i = 0; i < math.min(signal.length - windowSize, (maxStartOffset * sampleRate).toInt()); i++) {
      List<double> window = signal.sublist(i, i + windowSize);
      double windowCorrelation = 0.0;

      for (List<double> template in templateSineWaves) {
        double sum = 0.0;
        for (int j = 0; j < windowSize; j++) {
          sum += window[j] * template[j];
        }
        windowCorrelation += sum.abs();
      }

      correlation[i] = windowCorrelation;
    }

    int maxCorrelationIdx = correlation.indexWhere((double val) => val == correlation.reduce(math.max));
    double maxCorrelation = correlation[maxCorrelationIdx];

    if (maxCorrelation > bestCorrelation) {
      bestCorrelation = maxCorrelation;
      bestStart = maxCorrelationIdx;
    }

    return bestStart;
  }

  String decodeRecordedAudio(List<double> waveBytes) {
    List<double> templateFreqs = audioSettingsModel.possibleFrequencies.map((int f) => f.toDouble()).toList();
    double windowLength = 0.5;
    int maxStartOffset = 5;
    int startOffset = detectSignalStartDynamic(waveBytes, audioSettingsModel.sampleRate, templateFreqs, windowLength, maxStartOffset);
    List<double> trimmedWaveBytes = waveBytes.sublist(startOffset);
    List<int> detectedFrequencies = _parseWaveBytesToFrequencies(trimmedWaveBytes);
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
    List<int> detectedFrequencies = List<int>.filled(totalFrequenciesCount, 0);

    for (int sampleIndex = 0; sampleIndex < samplesCount; sampleIndex++) {
      List<double> chunkFrequencySample = _extractFrequencySample(waveBytes, sampleIndex);

      for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
        int highestFrequency = _findHighestFrequency(chunkFrequencySample, chunkIndex);
        int frequencyIndex = sampleIndex * chunksCount + chunkIndex;
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
    double angleStep = (2 * math.pi * frequency) / sampleRate;
    double sumCos = 0;
    double sumSin = 0;

    for (int i = 0; i < sampleCount; i++) {
      double sampleValue = samples[i] / audioSettingsModel.amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / sampleCount - 0.5);

      sumCos += sampleValue * math.cos(i * angleStep) * sincValue;
      sumSin += sampleValue * math.sin(i * angleStep) * sincValue;
    }

    double calculatedAmplitude = 2 * math.sqrt(sumCos * sumCos + sumSin * sumSin) / sampleCount;
    return calculatedAmplitude;
  }
}
