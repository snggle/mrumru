import 'dart:math';

import 'package:equatable/equatable.dart';

class AudioSettingsModel with EquatableMixin {
  late int baseFrequency;
  late int frequencyStep;
  late int sampleRate;
  late int bitDepth;
  late int channels;
  late int symbolDuration;
  late int bitsPerFrequency;

  AudioSettingsModel({
    required this.baseFrequency,
    required this.frequencyStep,
    required this.sampleRate,
    required this.bitDepth,
    required this.channels,
    required this.symbolDuration,
    required this.bitsPerFrequency,
  });

  AudioSettingsModel.withDefaults() {
    baseFrequency = 1000;
    frequencyStep = 100;
    bitDepth = 16;
    channels = 1;
    symbolDuration = 1;
    bitsPerFrequency = 4;
    sampleRate = 3 * calculateMaxFrequency();
  }

  void updateAudioSettings({
    int? baseFrequency,
    int? frequencyStep,
    int? sampleRate,
    int? bitDepth,
    int? channels,
    int? symbolDuration,
    int? bitsPerFrequency,
  }) {
    this.baseFrequency = baseFrequency ?? this.baseFrequency;
    this.frequencyStep = frequencyStep ?? this.frequencyStep;
    this.sampleRate = 3 * calculateMaxFrequency();
    this.bitDepth = bitDepth ?? this.bitDepth;
    this.channels = channels ?? this.channels;
    this.symbolDuration = symbolDuration ?? this.symbolDuration;
    this.bitsPerFrequency = bitsPerFrequency ?? this.bitsPerFrequency;
  }

  int calculateMaxFrequency() {
    int maxFrequency = (baseFrequency + (frequencyStep * (pow(2, bitsPerFrequency) - 1))).toInt();
    return maxFrequency;
  }

  @override
  List<Object?> get props => <Object>[baseFrequency, frequencyStep, sampleRate, bitDepth, channels, symbolDuration, bitsPerFrequency];
}
