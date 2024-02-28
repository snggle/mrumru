import 'dart:math';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/fsk/fsk_encoder.dart';
import 'package:mrumru/src/frame/frame_model_builder.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:wav/wav.dart';

class AudioGenerator {
  final AudioSettingsModel audioSettingsModel;
  final FrameModelBuilder frameModelBuilder;
  final FrameSettingsModel frameSettingsModel;
  final FskEncoder fskEncoder;

  AudioGenerator({
    required this.audioSettingsModel,
    required this.frameSettingsModel,
  })  : frameModelBuilder = FrameModelBuilder(frameSettingsModel: frameSettingsModel),
        fskEncoder = FskEncoder(audioSettingsModel);

  Uint8List generateWavFileBytes(String textMessage) {
    List<double> waveBytes = generateSamples(textMessage);
    List<Float64List> channels = <Float64List>[Float64List.fromList(waveBytes)];
    return Wav(channels, audioSettingsModel.sampleRate, WavFormat.float32).write();
  }

  List<double> generateSamples(String textMessage) {
    List<int> frequencies = _parseTextToFrequencySequence(textMessage);
    List<double> samples = _buildSamplesFromFrequencies(frequencies);
    List<double> samplesSum = _sumSamples(samples, audioSettingsModel.chunksCount);
    return <double>[
      ..._sumSamples(_startSequence, 2),
      ...samplesSum,
      ..._sumSamples(_endSequence, 2),
    ];
  }

  List<int> _parseTextToFrequencySequence(String text) {
    FrameCollectionModel frameCollectionModel = frameModelBuilder.buildFrameCollection(text);
    String binaryData = frameCollectionModel.mergedBinaryFrames;
    String filledBinaryData = _fillBinaryWithZeros(binaryData);
    return fskEncoder.encodeBinaryDataToFrequencies(filledBinaryData);
  }

  String _fillBinaryWithZeros(String binaryData) {
    int divider = audioSettingsModel.bitsPerFrequency * audioSettingsModel.chunksCount;
    int remainder = binaryData.length % divider;
    int zerosToAdd = remainder == 0 ? 0 : divider - remainder;
    return binaryData + List<String>.filled(zerosToAdd, '0').join('');
  }

  List<double> _sumSamples(List<double> samples, int chunksCount) {
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

  List<double> get _startSequence {
    List<int> template = audioSettingsModel.startFrequencies;
    List<double> samples = _buildSamplesFromFrequencies(template);
    return samples;
  }

  List<double> get _endSequence {
    List<int> template = audioSettingsModel.endFrequencies;
    List<double> samples = _buildSamplesFromFrequencies(template);
    return samples;
  }

  List<double> _buildSamplesFromFrequencies(List<int> frequencies) {
    List<double> samples = <double>[];

    for (int frequency in frequencies) {
      List<double> sampleBytes = _buildFrequencySample(frequency);
      samples.addAll(sampleBytes);
    }

    return samples;
  }

  List<double> _buildFrequencySample(int frequency) {
    List<double> sampleBytes = <double>[];

    for (int i = 0; i < audioSettingsModel.sampleSize; i++) {
      double angle = (2 * pi * i * frequency) / audioSettingsModel.sampleRate;
      double fadeMultiplier = _calcFadeMultiplier(i);

      sampleBytes.add(audioSettingsModel.amplitude * fadeMultiplier * sin(angle));
    }

    return sampleBytes;
  }

  double _calcFadeMultiplier(int index) {
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
