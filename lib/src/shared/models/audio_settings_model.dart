import 'dart:math';

import 'package:equatable/equatable.dart';

/// A model representing the settings for audio configuration.
class AudioSettingsModel with EquatableMixin {
  /// Static value for fade calculation
  static const double millisecondsInSeconds = 1000.0;

  /// Static value for maxOffset calculation. Provides the maximum number of skipped samples for the offset.
  static const int maxSkippedSamples = 7;

  /// Static value for samples calculation. Provides number of samples.
  static const int defaultSampleRate = 44000;

  /// Static value that provides the scale factor for the number of samples in WAV.
  static const double sampleScaleFactor = 2.5;

  /// The set of audio settings parameters.
  final int baseFrequency;
  final int bitsPerFrequency;
  final int channels;
  final int chunksCount;
  final int frequencyGap;
  final Duration fadeDuration;
  final Duration symbolDuration;
  final List<int> startFrequencies;
  final List<int> endFrequencies;
  late final int frequencyRange;
  late final int frequenciesCountPerChunk;
  late final int maxStartOffset;
  late final int sampleRate;
  late final int sampleSize;
  late final double amplitude;

  /// Creates an instance of [AudioSettingsModel].
  AudioSettingsModel({
    required this.baseFrequency,
    required this.bitsPerFrequency,
    required this.channels,
    required this.chunksCount,
    required this.frequencyGap,
    required this.fadeDuration,
    required this.symbolDuration,
    required this.startFrequencies,
    required this.endFrequencies,
    int? sampleRate,
  }) {
    frequenciesCountPerChunk = pow(2, bitsPerFrequency).toInt();
    this.sampleRate = sampleRate ?? max(defaultSampleRate, sampleScaleFactor * chunksCount * maxFrequency).toInt();
    amplitude = 1 / chunksCount;
    sampleSize = this.sampleRate * symbolDuration.inMilliseconds ~/ millisecondsInSeconds;
    frequencyRange = maxFrequency + frequencyGap;
    maxStartOffset = (maxSkippedSamples * sampleSize).toInt();
  }

  /// Creates an instance of [AudioSettingsModel] with default settings.
  factory AudioSettingsModel.withDefaults() {
    return AudioSettingsModel(
      baseFrequency: 400,
      bitsPerFrequency: 2,
      channels: 1,
      chunksCount: 4,
      frequencyGap: 200,
      fadeDuration: const Duration(milliseconds: 100),
      symbolDuration: const Duration(milliseconds: 200),
      startFrequencies: <int>[500, 700],
      endFrequencies: <int>[900, 1100],
    );
  }

  /// Creates a copy of this [AudioSettingsModel] with the given parameters.
  /// Any parameter that is not provided will use the value from the current instance.
  AudioSettingsModel copyWith({
    int? baseFrequency,
    int? bitDepth,
    int? bitsPerFrequency,
    int? channels,
    int? chunksCount,
    int? frequencyGap,
    int? sampleRate,
    Duration? fadeDuration,
    Duration? symbolDuration,
    List<int>? startFrequencies,
    List<int>? endFrequencies,
  }) {
    return AudioSettingsModel(
      baseFrequency: baseFrequency ?? this.baseFrequency,
      bitsPerFrequency: bitsPerFrequency ?? this.bitsPerFrequency,
      channels: channels ?? this.channels,
      chunksCount: chunksCount ?? this.chunksCount,
      frequencyGap: frequencyGap ?? this.frequencyGap,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      sampleRate: sampleRate ?? this.sampleRate,
      symbolDuration: symbolDuration ?? this.symbolDuration,
      startFrequencies: startFrequencies ?? this.startFrequencies,
      endFrequencies: endFrequencies ?? this.endFrequencies,
    );
  }

  /// Gets the maximum frequency based on the base frequency and frequency gap.
  int get maxFrequency {
    int maxFrequency = (baseFrequency + (frequencyGap * (frequenciesCountPerChunk - 1))).toInt();
    return maxFrequency;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  List<int> get possibleFrequencies {
    int numPossibleFrequencies = 1 << bitsPerFrequency;
    List<int> possibleFrequencies = List<int>.generate(numPossibleFrequencies, (int i) => baseFrequency + i * frequencyGap);

    return possibleFrequencies;
  }

  @override
  List<Object?> get props => <Object>[
        amplitude,
        baseFrequency,
        bitsPerFrequency,
        channels,
        chunksCount,
        frequencyGap,
        frequencyRange,
        frequenciesCountPerChunk,
        fadeDuration,
        maxStartOffset,
        symbolDuration,
        startFrequencies,
        endFrequencies,
        sampleRate,
        sampleSize,
      ];
}
