import 'dart:math';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/fsk/fsk_encoder.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

class AudioGenerator {
  final AudioSettingsModel audioSettingsModel;
  final WavEncoder wavEncoder;
  final FskEncoder fskEncoder;

  AudioGenerator({required this.audioSettingsModel})
      : wavEncoder = WavEncoder(
          audioSettingsModel.channels,
          audioSettingsModel.sampleRate,
          audioSettingsModel.bitDepth,
        ),
        fskEncoder = FskEncoder(
          baseFrequency: audioSettingsModel.baseFrequency,
          frequencyStep: audioSettingsModel.frequencyStep,
          bitsPerFrequency: audioSettingsModel.bitsPerFrequency,
        );

  List<int> generateAudioBytes(String textMessage) {
    List<int> frequencies = _parseTextToFrequencySequence(textMessage);
    List<int> samples = _buildSamples(frequencies);
    return wavEncoder.buildWavFromSamples(samples);
  }

  List<int> _parseTextToFrequencySequence(String text) {
    String binaryText = BinaryUtils.convertAsciiToBinary(text);
    return fskEncoder.encodeBinaryDataToFrequencies(binaryText);
  }

  List<int> _buildSamples(List<int> frequencies) {
    List<int> samples = <int>[];
    double amplitude = (1 << 15) - 1;
    int sampleCount = audioSettingsModel.sampleRate * audioSettingsModel.symbolDuration;

    for (int frequency in frequencies) {
      samples.addAll(_buildFrequencySamples(frequency, sampleCount, amplitude));
    }

    return samples;
  }

  List<int> _buildFrequencySamples(int frequency, int sampleCount, double amplitude) {
    List<int> samples = <int>[];

    for (int i = 0; i < sampleCount; i++) {
      double angle = (2 * pi * i * frequency) / audioSettingsModel.sampleRate;
      int sample = (amplitude * sin(angle)).round();
      samples.add(sample);
    }

    return samples;
  }
}
