import 'dart:math';

import 'package:equatable/equatable.dart';

class AudioSettingsModel with EquatableMixin {
  final int baseFrequency;
  final int bitsPerFrequency;
  final int channels;
  final int chunksCount;
  final int frequencyGap;
  final double fadeDuration;
  final Duration symbolDuration;
  final List<int> startFrequencies;
  final List<int> endFrequencies;
  late final double amplitude;
  late final int frequencyRange;
  late final int maxStartOffset;
  late final int sampleRate;
  late final int sampleSize;

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
    this.sampleRate = sampleRate ?? max(44000, 2.5 * chunksCount * maxFrequency).toInt();
    amplitude = 1 / chunksCount;
    sampleSize = this.sampleRate * symbolDuration.inMilliseconds ~/ 1000;
    frequencyRange = maxFrequency + frequencyGap;
    maxStartOffset = (7 * sampleSize).toInt();
  }

  factory AudioSettingsModel.withDefaults() {
    return AudioSettingsModel(
      baseFrequency: 400,
      bitsPerFrequency: 2,
      channels: 1,
      chunksCount: 4,
      frequencyGap: 200,
      fadeDuration: 0.1,
      symbolDuration: const Duration(milliseconds: 150),
      startFrequencies: <int>[500, 700],
      endFrequencies: <int>[900, 1100],
    );
  }

  AudioSettingsModel copyWith({
    int? baseFrequency,
    int? bitDepth,
    int? bitsPerFrequency,
    int? channels,
    int? chunksCount,
    int? frequencyGap,
    int? sampleRate,
    double? fadeDuration,
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

  int get maxFrequency {
    int maxFrequency = (baseFrequency + (frequencyGap * (pow(2, bitsPerFrequency) - 1))).toInt();
    return maxFrequency;
  }

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
        fadeDuration,
        maxStartOffset,
        symbolDuration,
        startFrequencies,
        endFrequencies,
        sampleRate,
        sampleSize,
      ];
}
