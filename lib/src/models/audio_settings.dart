import 'dart:math';

import 'package:equatable/equatable.dart';

class AudioSettingsModel with EquatableMixin {
  late int baseFrequency;
  late int bitDepth;
  late int bitsPerFrequency;
  late int channels;
  late int frequencyStep;
  late int symbolDuration;
  late int sampleRate;

  AudioSettingsModel({
    required this.baseFrequency,
    required this.bitDepth,
    required this.bitsPerFrequency,
    required this.channels,
    required this.frequencyStep,
    required this.symbolDuration,
    required this.sampleRate,
  });

  AudioSettingsModel.withDefaults() {
    baseFrequency = 1000;
    bitDepth = 16;
    bitsPerFrequency = 4;
    channels = 1;
    frequencyStep = 100;
    symbolDuration = 1;
    sampleRate = 3 * maxFrequency;
  }

  void updateAudioSettings({
    int? baseFrequency,
    int? bitDepth,
    int? bitsPerFrequency,
    int? channels,
    int? frequencyStep,
    int? symbolDuration,
    int? sampleRate,
  }) {
    this.baseFrequency = baseFrequency ?? this.baseFrequency;
    this.bitDepth = bitDepth ?? this.bitDepth;
    this.bitsPerFrequency = bitsPerFrequency ?? this.bitsPerFrequency;
    this.channels = channels ?? this.channels;
    this.frequencyStep = frequencyStep ?? this.frequencyStep;
    this.symbolDuration = symbolDuration ?? this.symbolDuration;
    this.sampleRate = 3 * maxFrequency;
  }

  int get maxFrequency {
    int maxFrequency = (baseFrequency + (frequencyStep * (pow(2, bitsPerFrequency) - 1))).toInt();
    return maxFrequency;
  }

  @override
  List<Object?> get props => <Object>[baseFrequency, bitDepth, bitsPerFrequency, channels, frequencyStep, symbolDuration, sampleRate];
}
