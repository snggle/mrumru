import 'package:flutter/material.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/correlation/frequency_correlation_calculator.dart';
import 'package:mrumru/src/audio/correlation/index_correlation_calculator.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/decoded_frequency.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/log_level.dart';

class PacketRecognizer {
  final AudioSettingsModel audioSettingsModel;
  final VoidCallback onDecodingCompleted;
  final int sampleSize;
  final int sampleRate;
  final int chunksCount;
  final double amplitude;
  final List<int> startFrequencies;

  late final int maxStartOffset = (15 * sampleSize).toInt();
  late final FrameModelDecoder frameModelDecoder;
  final ValueNotifier<List<double>> originalWave = ValueNotifier<List<double>>(<double>[]);

  int? startOffset;
  int? endOffset;
  int cursor = 0;
  bool processing = false;

  PacketRecognizer({
    required this.audioSettingsModel,
    required this.onDecodingCompleted,
    required FrameSettingsModel frameSettingsModel,
    ValueChanged<FrameModel>? onFrameDecoded,
  })  : sampleSize = audioSettingsModel.sampleSize,
        sampleRate = audioSettingsModel.sampleRate,
        chunksCount = audioSettingsModel.chunksCount,
        amplitude = audioSettingsModel.amplitude,
        startFrequencies = audioSettingsModel.startFrequencies {
    frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: _handleFirstFrameDecoded,
      onLastFrameDecoded: (_) => _finishDecoding(),
      onFrameDecoded: onFrameDecoded,
    );
  }

  void addPacket(List<double> packet) {
    AppLogger().log(message: 'Add packet (Size: ${packet.length})', logLevel: LogLevel.debug);
    originalWave.value = <double>[...originalWave.value, ...packet];
    if (_isInitialOffsetReached) {
      AppLogger().log(message: 'Initial range reached. Find initial index and start decoding', logLevel: LogLevel.debug);
      _findStartOffset(List<double>.from(originalWave.value));
      _startDecoding();
    }
  }

  FrameCollectionModel get decodedContent {
    return frameModelDecoder.decodedContent;
  }

  bool get _isInitialOffsetReached => startOffset == null && originalWave.value.length >= maxStartOffset;

  void _findStartOffset(List<double> wave) {
    IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    startOffset = correlationCalculator.findBestIndex(originalWave.value, startFrequencies);
    AppLogger().log(message: 'Start offset found: $startOffset', logLevel: LogLevel.debug);
  }

  void _startDecoding() {
    assert(startOffset != null, 'Start offset must be set before decoding');
    cursor = startOffset!;
    AppLogger().log(message: 'Set cursor to $cursor', logLevel: LogLevel.debug);

    _processData();
    originalWave.addListener(_handleWaveUpdated);
  }

  void _handleWaveUpdated() {
    if (processing == false) {
      try {
        _processData();
      } catch (e) {
        AppLogger().log(message: 'Error while processing data: $e', logLevel: LogLevel.error);
      }
    }
  }

  void _processData() {
    AppLogger().log(message: 'Process data (Cursor position: $cursor)', logLevel: LogLevel.debug);
    processing = true;
    if (_isEndOffsetReached || cursor > originalWave.value.length) {
      _finishDecoding();
      return;
    }

    List<double> waveToProcess = originalWave.value.sublist(cursor);
    int sampleCount = waveToProcess.length ~/ sampleSize;
    for (int i = 0; i < sampleCount; i++) {
      List<double> sample = waveToProcess.sublist(i * sampleSize, (i + 1) * sampleSize);
      List<DecodedFrequency> frequencies = _translateSampleToFrequency(sample);
      _decodeFrequencies(frequencies);
      cursor += sampleSize;
      AppLogger().log(message: 'Set cursor to $cursor', logLevel: LogLevel.debug);
    }
    processing = false;
  }

  bool get _isEndOffsetReached => endOffset != null && cursor >= endOffset!;

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    endOffset = frameModel.getTransferWavLength(audioSettingsModel);
    AppLogger().log(
      message: 'Decoded first frame. Expecting ${frameModel.framesCount} frames (${frameModel.getTransferWavLength(audioSettingsModel)} wave length)',
      logLevel: LogLevel.debug,
    );
  }

  void _finishDecoding() {
    AppLogger().log(message: 'Finished decoding', logLevel: LogLevel.debug);
    onDecodingCompleted();
  }

  void _decodeFrequencies(List<DecodedFrequency> translatedFrequencies) {
    List<String> binaries = translatedFrequencies.map((DecodedFrequency e) => e.calcBinary(audioSettingsModel)).toList();
    frameModelDecoder.addBinaries(binaries);
  }

  List<DecodedFrequency> _translateSampleToFrequency(List<double> sample) {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);

    List<DecodedFrequency> frequencies = <DecodedFrequency>[];
    for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      DecodedFrequency decodedFrequency = DecodedFrequency(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
      frequencies.add(decodedFrequency);
    }
    return frequencies;
  }
}
