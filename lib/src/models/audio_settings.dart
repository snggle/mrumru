import 'dart:math';

import 'package:equatable/equatable.dart';

class AudioSettingsModel with EquatableMixin {
  final int baseFrequency;
  final int bitDepth;
  final int bitsPerFrequency;
  final int channels;
  final int chunksCount;
  final int frequencyGap;
  final double symbolDuration;
  late final double amplitude;
  late final int frequencyRange;
  late final int sampleRate;
  late final int sampleSize;

  AudioSettingsModel({
    required this.baseFrequency,
    required this.bitDepth,
    required this.bitsPerFrequency,
    required this.channels,
    required this.chunksCount,
    required this.frequencyGap,
    required this.symbolDuration,
  }) {
    amplitude = 1 / chunksCount;
    sampleRate = (2.5 * chunksCount * maxFrequency).toInt();
    sampleSize = (sampleRate * symbolDuration).toInt();
    frequencyRange = maxFrequency + frequencyGap;
  }

  factory AudioSettingsModel.withDefaults() {
    return AudioSettingsModel(
      baseFrequency: 400,
      bitDepth: 16,
      bitsPerFrequency: 2,
      channels: 1,
      chunksCount: 2,
      frequencyGap: 200,
      symbolDuration: 0.5,
    );
  }

  AudioSettingsModel copyWith({
    int? baseFrequency,
    int? bitDepth,
    int? bitsPerFrequency,
    int? channels,
    int? chunksCount,
    int? frequencyGap,
    double? symbolDuration,
  }) {
    return AudioSettingsModel(
      baseFrequency: baseFrequency ?? this.baseFrequency,
      bitDepth: bitDepth ?? this.bitDepth,
      bitsPerFrequency: bitsPerFrequency ?? this.bitsPerFrequency,
      channels: channels ?? this.channels,
      chunksCount: chunksCount ?? this.chunksCount,
      frequencyGap: frequencyGap ?? this.frequencyGap,
      symbolDuration: symbolDuration ?? this.symbolDuration,
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
        bitDepth,
        bitsPerFrequency,
        channels,
        chunksCount,
        frequencyGap,
        frequencyRange,
        symbolDuration,
        sampleRate,
        sampleSize,
      ];
}
