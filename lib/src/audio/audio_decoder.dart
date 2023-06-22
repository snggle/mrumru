import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/fsk/fsk_decoder.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/math_utils.dart';

class AudioDecoder {
  final WavDecoder wavDecoder;
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;
  final FrameModelDecoder frameModelDecoder;
  final FskDecoder fskDecoder;

  AudioDecoder({required this.audioSettingsModel, required this.frameSettingsModel})
      : fskDecoder = FskDecoder(
          baseFrequency: audioSettingsModel.baseFrequency,
          frequencyStep: audioSettingsModel.frequencyStep,
          bitsPerFrequency: audioSettingsModel.bitsPerFrequency,
        ),
        wavDecoder = WavDecoder(
          audioSettingsModel.channels,
          audioSettingsModel.sampleRate,
          audioSettingsModel.bitDepth,
        ),
        frameModelDecoder = FrameModelDecoder(framesSettingsModel: frameSettingsModel);

  Future<String> decodeRecordedAudio(Uint8List wavBytes) async {
    List<int> samples = wavDecoder.readSamplesFromWav(wavBytes);
    List<int> frequencies = _parseSamplesToFrequencySequence(samples);
    String binaryData = fskDecoder.decodeFrequenciesToBinary(frequencies);
    FrameCollectionModel frameCollectionModel = frameModelDecoder.decodeBinaryData(binaryData);
    return frameCollectionModel.mergedRawData;
  }

  List<int> _parseSamplesToFrequencySequence(List<int> samples) {
    int sampleCount = audioSettingsModel.sampleRate * audioSettingsModel.symbolDuration;
    int frequencyCount = samples.length ~/ sampleCount;
    int maxFrequency = audioSettingsModel.baseFrequency + (audioSettingsModel.frequencyStep * (pow(2, audioSettingsModel.bitsPerFrequency).toInt()));
    List<int> frequencies = <int>[];

    for (int frequencyIndex = 0; frequencyIndex < frequencyCount; frequencyIndex++) {
      int startSampleIndex = frequencyIndex * sampleCount;
      int endSampleIndex = startSampleIndex + sampleCount;
      List<int> sampleBytes = samples.sublist(startSampleIndex, endSampleIndex);

      frequencies.add(_recognizeFrequency(sampleBytes, maxFrequency));
    }
    return frequencies;
  }

  int _recognizeFrequency(List<int> sampleBytes, int maxFrequency) {
    int detectedFrequency = 0;
    double maxAmplitude = 0;

    for (int frequency = audioSettingsModel.baseFrequency; frequency < maxFrequency; frequency += audioSettingsModel.frequencyStep) {
      double amplitude = _calculateAmplitude(sampleBytes, frequency);
      if (amplitude > maxAmplitude) {
        maxAmplitude = amplitude;
        detectedFrequency = frequency;
      }
    }

    return detectedFrequency;
  }

  double _calculateAmplitude(List<int> samples, int frequency) {
    int sampleCount = samples.length;
    double angleStep = (2 * pi * frequency) / audioSettingsModel.sampleRate;

    double sumCos = 0;
    double sumSin = 0;

    for (int i = 0; i < sampleCount; i++) {
      double sampleValue = samples[i] / ((1 << 15) - 1);
      double sincValue = MathUtils.sinc(i.toDouble() / sampleCount - 0.5);

      sumCos += sampleValue * cos(i * angleStep) * sincValue;
      sumSin += sampleValue * sin(i * angleStep) * sincValue;
    }
    double calculatedAmplitude = 2 * sqrt(sumCos * sumCos + sumSin * sumSin) / sampleCount;
    return calculatedAmplitude;
  }
}
