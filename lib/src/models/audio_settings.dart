import 'package:equatable/equatable.dart';

class AudioSettingsModel with EquatableMixin {
  int baseFrequency;
  int frequencyStep;
  int sampleRate;
  int bitDepth;
  int channels;
  int symbolDuration;
  int bitsPerFrequency;

  AudioSettingsModel({
    required this.baseFrequency,
    required this.frequencyStep,
    required this.sampleRate,
    required this.bitDepth,
    required this.channels,
    required this.symbolDuration,
    required this.bitsPerFrequency,
  });

  AudioSettingsModel.withDefaults({
    this.baseFrequency = 1000,
    this.frequencyStep = 100,
    this.sampleRate = 44100,
    this.bitDepth = 16,
    this.channels = 1,
    this.symbolDuration = 1,
    this.bitsPerFrequency = 4,
  });

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
    this.sampleRate = sampleRate ?? this.sampleRate;
    this.bitDepth = bitDepth ?? this.bitDepth;
    this.channels = channels ?? this.channels;
    this.symbolDuration = symbolDuration ?? this.symbolDuration;
    this.bitsPerFrequency = bitsPerFrequency ?? this.bitsPerFrequency;
  }

  @override
  List<Object?> get props => <Object>[baseFrequency, frequencyStep, sampleRate, bitDepth, channels, symbolDuration, bitsPerFrequency];
}
