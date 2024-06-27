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
  final int baseFrequencyGap;
  final Duration fadeDuration;
  final Duration symbolDuration;
  final List<int> startFrequencies;
  final List<int> endFrequencies;

  late final int maxStartOffset;
  late final int sampleRate;
  late final int sampleSize;
  late final int maxBaseFrequency;
  late final int frequenciesCountPerChunk;
  late final double amplitude;
  final double frequencyCoefficient;
  late final List<int> allPossibleFrequencies;
  late final List<int> possibleBaseFrequencies;
  late final List<List<int>> possibleFrequenciesForChunks;

  /// Creates an instance of [AudioSettingsModel].
  AudioSettingsModel({
    required this.baseFrequency,
    required this.bitsPerFrequency,
    required this.channels,
    required this.chunksCount,
    required this.baseFrequencyGap,
    required this.fadeDuration,
    required this.symbolDuration,
    required this.startFrequencies,
    required this.endFrequencies,
    required this.frequencyCoefficient,
    int? sampleRate,
  }) {
    frequenciesCountPerChunk = pow(2, bitsPerFrequency).toInt();
    allPossibleFrequencies = _possibleFrequencies();
    possibleBaseFrequencies = _calcPossibleBaseFrequencies();
    maxBaseFrequency = _calcMaxBaseFrequency();
    possibleFrequenciesForChunks = _calcPossibleFrequenciesForChunks();
    this.sampleRate = sampleRate ?? max(defaultSampleRate, sampleScaleFactor * chunksCount * maxBaseFrequency).toInt();
    amplitude = 1 / chunksCount;
    sampleSize = this.sampleRate * symbolDuration.inMilliseconds ~/ millisecondsInSeconds;

    maxStartOffset = (maxSkippedSamples * sampleSize).toInt();
  }

  /// Creates an instance of [AudioSettingsModel] with default settings.
  factory AudioSettingsModel.withDefaults() {
    return AudioSettingsModel(
      baseFrequency: 400,
      bitsPerFrequency: 2,
      channels: 1,
      chunksCount: 16,
      baseFrequencyGap: 200,
      fadeDuration: const Duration(milliseconds: 100),
      symbolDuration: const Duration(milliseconds: 200),
      startFrequencies: <int>[500, 700],
      endFrequencies: <int>[900, 1100],
      frequencyCoefficient : 1 / 340,
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
    int? baseFrequencyGap,
    int? sampleRate,
    double? frequencyCoefficient,
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
      baseFrequencyGap: baseFrequencyGap ?? this.baseFrequencyGap,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      frequencyCoefficient: frequencyCoefficient ?? this.frequencyCoefficient,
      sampleRate: sampleRate ?? this.sampleRate,
      symbolDuration: symbolDuration ?? this.symbolDuration,
      startFrequencies: startFrequencies ?? this.startFrequencies,
      endFrequencies: endFrequencies ?? this.endFrequencies,
    );
  }

  /// Gets the list of possible frequencies with adjusted gap based on the base frequency and frequency gap.
  List<int> getPossibleFrequenciesWithAdjustedGap() {
    List<int> possibleFrequencies = _possibleFrequencies();
    List<int> adjustedFrequencies = <int>[baseFrequency];

    for (int i = 1; i < possibleFrequencies.length; i++) {
      int frequency = possibleFrequencies[i];
      int gap = (frequency * frequencyCoefficient).round();

      int adjustedFrequency = frequency + gap;
      adjustedFrequencies.add(adjustedFrequency);
    }

    return adjustedFrequencies;
  }

  /// Gets dynamic gap for the given frequencies.
  List<int> assignDynamicGap(List<int> frequencies) {
    List<int> possibleFrequencies = _possibleFrequencies();
    List<int> possibleFrequenciesWithAdjustedGap = getPossibleFrequenciesWithAdjustedGap();

    List<int> frequenciesWithAdjustedGap = <int>[];
    for (int frequency in frequencies) {
      int index = possibleFrequencies.indexOf(frequency);
      int adjustedFrequency = possibleFrequenciesWithAdjustedGap[index];
      frequenciesWithAdjustedGap.add(adjustedFrequency);
    }

    return frequenciesWithAdjustedGap;
  }

  /// Gets un dynamic gap for the given frequency.
  int removeDynamicGap(int frequency) {
    List<int> possibleFrequencies = _possibleFrequencies();
    List<int> possibleFrequenciesWithAdjustedGap = getPossibleFrequenciesWithAdjustedGap();

    int index = possibleFrequenciesWithAdjustedGap.indexOf(frequency);
    int adjustedFrequency = possibleFrequencies[index];

    return adjustedFrequency;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  int parseFrequencyToChunkFrequency(int frequency, int chunkIndex) {
    int alignedFrequency = frequency - baseFrequency;
    int alignedMaxBaseFrequency = maxBaseFrequency - baseFrequency;

    int chunkShift = chunkIndex * alignedMaxBaseFrequency;
    int chunkedFrequency = alignedFrequency + chunkShift + baseFrequency + (chunkIndex * baseFrequencyGap);

    return chunkedFrequency;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  int parseChunkFrequencyToFrequency(int chunkFrequency, int chunkIndex) {
    int alignedMaxBaseFrequency = maxBaseFrequency - baseFrequency;

    int chunkShift = chunkIndex * alignedMaxBaseFrequency;
    int alignedChunkFrequency = chunkFrequency - chunkShift - baseFrequency - (chunkIndex * baseFrequencyGap);

    int originalFrequency = alignedChunkFrequency + baseFrequency;

    return originalFrequency;
  }

  List<int> getPossibleFrequenciesForChunk(int chunkIndex) {
    return possibleFrequenciesForChunks[chunkIndex];
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  List<int> _possibleFrequencies() {
    int possibleFrequenciesCount = frequenciesCountPerChunk * chunksCount;
    List<int> possibleFrequencies = List<int>.generate(possibleFrequenciesCount, (int i) => baseFrequency + i * baseFrequencyGap);

    return possibleFrequencies;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  List<List<int>> _calcPossibleFrequenciesForChunks() {
    List<List<int>> possibleFrequenciesForChunks = <List<int>>[];
    for (int i = 0; i < chunksCount; i++) {
      List<int> possibleFrequenciesForChunk = _calcPossibleFrequenciesForChunk(i);
      possibleFrequenciesForChunks.add(possibleFrequenciesForChunk);
    }
    return possibleFrequenciesForChunks;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  List<int> _calcPossibleFrequenciesForChunk(int chunkIndex) {
    List<int> possibleFrequenciesWithAdjustedGap = getPossibleFrequenciesWithAdjustedGap();
    int chunkStart = frequenciesCountPerChunk * chunkIndex;
    int chunkEnd = chunkStart + frequenciesCountPerChunk;

    return possibleFrequenciesWithAdjustedGap.sublist(chunkStart, chunkEnd);
  }

  /// Gets the maximum frequency based on the base frequency and frequency gap.
  int _calcMaxBaseFrequency() {
    return possibleBaseFrequencies.last;
  }

  /// Gets the list of possible frequencies based on the base frequency and frequency gap.
  List<int> _calcPossibleBaseFrequencies() {
    List<int> possibleFrequencies = List<int>.generate(frequenciesCountPerChunk, (int i) => baseFrequency + (i * baseFrequencyGap));

    return possibleFrequencies;
  }

  @override
  List<Object?> get props => <Object>[
        amplitude,
        baseFrequency,
        bitsPerFrequency,
        channels,
        chunksCount,
        baseFrequencyGap,
        frequenciesCountPerChunk,
        fadeDuration,
        frequencyCoefficient,
        maxStartOffset,
        symbolDuration,
        startFrequencies,
        endFrequencies,
        sampleRate,
        sampleSize,
      ];
}
