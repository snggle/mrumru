import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:stream_isolate/stream_isolate.dart';

typedef SampleCreatedCallback = void Function(Float32List sample);

class SampleGenerator {
  final AudioSettingsModel audioSettingsModel;

  SampleGenerator(this.audioSettingsModel);

  Future<void> buildSamples(List<List<int>> frequencies, SampleCreatedCallback onSampleCreated) async {
    StreamIsolate<Float32List, void> streamIsolate = await StreamIsolate.spawn(() => _parseFrequenciesToSamples(frequencies, audioSettingsModel));
    await for (Float32List sample in streamIsolate.stream) {
      onSampleCreated(sample);
    }
  }

  static Stream<Float32List> _parseFrequenciesToSamples(List<List<int>> frequencies, AudioSettingsModel audioSettingsModel) async* {
    for (List<int> sampleFrequencies in frequencies) {
      List<double> sample = _buildSamplesFromFrequencies(sampleFrequencies, audioSettingsModel);
      List<double> sampleSum = _splitAndSumSamples(sample, sampleFrequencies.length);
      yield Float32List.fromList(sampleSum);
    }
  }

  static List<double> _buildSamplesFromFrequencies(List<int> frequencies, AudioSettingsModel audioSettingsModel) {
    List<double> samples = <double>[];

    for (int frequency in frequencies) {
      List<double> sampleBytes = _buildFrequencySample(frequency, audioSettingsModel);
      samples.addAll(sampleBytes);
    }

    return samples;
  }

  static List<double> _splitAndSumSamples(List<double> samples, int chunksCount) {
    int length = samples.length;
    int splitLength = length ~/ chunksCount;
    int remainder = length % chunksCount;

    List<List<double>> splitSamples = <List<double>>[];
    int start = 0;
    int end = splitLength;

    for (int i = 0; i < chunksCount; i++) {
      if (remainder > 0) {
        end += 1;
        remainder -= 1;
      }
      splitSamples.add(samples.sublist(start, end));
      start = end;
      end += splitLength;
    }

    int maxLength = splitSamples.map((List<double> samples) => samples.length).reduce(max);
    List<double> summedSamples = List<double>.filled(maxLength, 0.0);

    for (List<double> samples in splitSamples) {
      for (int i = 0; i < samples.length; i++) {
        summedSamples[i] += samples[i];
      }
    }

    return summedSamples;
  }

  static List<double> _buildFrequencySample(int frequency, AudioSettingsModel audioSettingsModel) {
    List<double> sampleBytes = <double>[];

    for (int i = 0; i < audioSettingsModel.sampleSize; i++) {
      double angle = (2 * pi * i * frequency) / audioSettingsModel.sampleRate;
      double fadeMultiplier = _calcFadeMultiplier(i, audioSettingsModel);

      sampleBytes.add(audioSettingsModel.amplitude * fadeMultiplier * sin(angle));
    }

    return sampleBytes;
  }

  static double _calcFadeMultiplier(int index, AudioSettingsModel audioSettingsModel) {
    int sampleRate = audioSettingsModel.sampleRate;
    int sampleSize = audioSettingsModel.sampleSize;
    double fadeDuration = audioSettingsModel.fadeDuration;
    int fadeSize = (sampleRate * fadeDuration).toInt();
    double fadeMultiplier = 1.0;

    if (index < fadeSize) {
      fadeMultiplier = index / fadeSize;
    } else if (index > sampleSize - fadeSize) {
      fadeMultiplier = (sampleSize - index) / fadeSize;
    }

    return fadeMultiplier;
  }
}
