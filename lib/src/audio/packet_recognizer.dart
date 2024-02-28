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

  late final int maxStartOffset;
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
        startFrequencies = audioSettingsModel.startFrequencies,
        maxStartOffset = (15 * audioSettingsModel.sampleSize).toInt() {
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
    if (_isInitialOffsetReached()) {
      _findStartOffset();
      _startDecoding();
    }
  }

  FrameCollectionModel get decodedContent => frameModelDecoder.decodedContent;

  bool _isInitialOffsetReached() => startOffset == null && originalWave.value.length >= maxStartOffset;

  void _findStartOffset() {
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
    if (!processing) {
      try {
        _processData();
      } catch (e) {
        AppLogger().log(message: 'Error while processing data: $e', logLevel: LogLevel.error);
      }
    }
  }

  void _processData() {
    processing = true;
    if (_isEndOffsetReached() || cursor > originalWave.value.length) {
      _finishDecoding();
      return;
    }

    while (cursor + sampleSize <= originalWave.value.length) {
      List<double> sample = originalWave.value.sublist(cursor, cursor + sampleSize);
      List<DecodedFrequency> frequencies = _translateSampleToFrequency(sample);
      _decodeFrequencies(frequencies);
      cursor += sampleSize;
    }
    processing = false;
  }

  bool _isEndOffsetReached() => endOffset != null && cursor >= endOffset!;

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    endOffset = frameModel.getTransferWavLength(audioSettingsModel);
  }

  void _finishDecoding() {
    AppLogger().log(message: 'Finished decoding', logLevel: LogLevel.debug);
    originalWave.removeListener(_handleWaveUpdated);
    onDecodingCompleted();
  }

  List<DecodedFrequency> _translateSampleToFrequency(List<double> sample) {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    return List<DecodedFrequency>.generate(chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequency(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
  }

  void _decodeFrequencies(List<DecodedFrequency> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequency frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    frameModelDecoder.addBinaries(binaries);
  }
}
