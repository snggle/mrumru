import 'dart:math';
import 'dart:typed_data';

import 'package:mrumru/src/shared/models/audio_settings_model.dart';

/// A class that runs in an isolate to generate audio samples from frequencies.
class SamplesGeneratorThread {
  /// The size of each sample.
  final int _sampleSize;

  /// The sample rate of the audio data.
  final int _sampleRate;

  /// The amplitude of the audio signal.
  final double _amplitude;

  /// The duration of the fade effect.
  final Duration _fadeDuration;

  /// Creates an instance of [SamplesGeneratorThread].
  SamplesGeneratorThread(AudioSettingsModel audioSettingsModel)
      : _sampleSize = audioSettingsModel.sampleSize,
        _sampleRate = audioSettingsModel.sampleRate,
        _amplitude = audioSettingsModel.amplitude,
        _fadeDuration = audioSettingsModel.fadeDuration;

  /// This method converts each chunk of frequencies into audio samples and yields them.
  Stream<Float32List> parseFrequenciesToSamples(
      List<List<int>> frequencies,
      Duration Function(int) symbolDurationCalculator, // Accept calculator
      ) async* {
    for (List<int> sampleFrequencies in frequencies) {
      List<double> samples = _buildSamplesFromFrequencies(
        sampleFrequencies,
        symbolDurationCalculator,
      );
      List<double> sampleSum = _splitAndSumSamples(samples, sampleFrequencies.length);
      yield Float32List.fromList(sampleSum);
    }
  }

  /// This method converts each frequency into a list of samples.
  List<double> _buildSamplesFromFrequencies(
      List<int> frequencies,
      Duration Function(int) symbolDurationCalculator,
      ) {
    List<double> samples = <double>[];
    for (int frequency in frequencies) {
      Duration symbolDuration = symbolDurationCalculator(frequency);
      List<double> sampleBytes = _buildFrequencySample(frequency, symbolDuration);
      samples.addAll(sampleBytes);
    }
    return samples;
  }

  /// Splits and sums the given list of [samples] into smaller chunks.
  List<double> _splitAndSumSamples(List<double> samples, int chunksCount) {
    int splitLength = samples.length ~/ chunksCount;
    int remainder = samples.length % chunksCount;

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

  /// This method generates a list of samples for the specified frequency, applying a fade effect.
  List<double> _buildFrequencySample(int frequency, Duration symbolDuration) {
    List<double> sampleBytes = <double>[];
    int sampleSize = _sampleRate * symbolDuration.inMilliseconds ~/ AudioSettingsModel.millisecondsInSeconds; // Adjust sample size based on symbol duration

    for (int i = 0; i < sampleSize; i++) {
      double angle = (2 * pi * i * frequency) / _sampleRate;
      double fadeMultiplier = _calcFadeMultiplier(i, sampleSize); // Pass sampleSize to fade multiplier

      sampleBytes.add(_amplitude * fadeMultiplier * sin(angle));
    }

    return sampleBytes;
  }

  /// This method applies a fade effect to the samples based on the fade duration and sample size.
  double _calcFadeMultiplier(int index, int sampleSize) {
    double fadeDurationInSeconds = _fadeDuration.inMilliseconds / AudioSettingsModel.millisecondsInSeconds;
    int fadeSize = (_sampleRate * fadeDurationInSeconds).toInt();
    double fadeMultiplier = 1.0;

    if (index < fadeSize) {
      fadeMultiplier = index / fadeSize;
    } else if (index > sampleSize - fadeSize) {
      fadeMultiplier = (sampleSize - index) / fadeSize;
    }

    return fadeMultiplier;
  }
}
