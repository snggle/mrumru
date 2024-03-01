import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/correlation/frequency_correlation_calculator.dart';
import 'package:mrumru/src/audio/correlation/index_correlation_calculator.dart';
import 'package:mrumru/src/audio/packet_event.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/decoded_frequency.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/log_level.dart';

class PacketRecognizer {
  final AudioSettingsModel audioSettingsModel;
  final VoidCallback onDecodingCompleted;

  final List<int> startFrequencies;

  late final int maxStartOffset;
  late final FrameModelDecoder frameModelDecoder;
  final List<PacketEvent> _queue = <PacketEvent>[];

  int? startOffset;
  int? endOffset;
  bool recordingBool = false;

  PacketRecognizer({
    required this.audioSettingsModel,
    required this.onDecodingCompleted,
    required FrameSettingsModel frameSettingsModel,
    ValueChanged<FrameModel>? onFrameDecoded,
  })  : startFrequencies = audioSettingsModel.startFrequencies,
        maxStartOffset = (15 * audioSettingsModel.sampleSize).toInt() {
    frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: _handleFirstFrameDecoded,
      onLastFrameDecoded: (_) => _finishDecoding(),
      onFrameDecoded: onFrameDecoded,
    );
  }

  Future<void> addPacket(ReceivedPacketEvent packet) async {
    AppLogger().log(message: 'Add packet (Size: ${packet.packet.length})', logLevel: LogLevel.debug);
    _queue.add(packet);
    await _startDecoding();
  }

  FrameCollectionModel get decodedContent => frameModelDecoder.decodedContent;

  bool _isInitialOffsetReached() {
    int totalLength = 0;
    for (PacketEvent event in _queue) {
      totalLength += event.packet.length;
      if (totalLength >= maxStartOffset) {
        return true;
      }
    }
    return false;
  }

  void _findStartOffset() {
    IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    List<double> dataToProcess = <double>[];
    while (dataToProcess.length < maxStartOffset && _queue.isNotEmpty) {
      PacketEvent event = _queue.removeAt(0);
      dataToProcess.addAll(event.packet);
    }
    startOffset = correlationCalculator.findBestIndex(dataToProcess, startFrequencies);

    List<double> remainingData = dataToProcess.sublist(startOffset!);
    _queue.insert(0, RemainingPacketEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $startOffset', logLevel: LogLevel.debug);
  }

  Future<void> _startDecoding() async {
    do {
      if (startOffset == null) {
        if (_isInitialOffsetReached()) {
          _findStartOffset();
        }
      } else {
        _processData();
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } while (_queue.isNotEmpty && recordingBool);
  }

  void _processData() {
    List<double> dataToProcess = <double>[];
    while (dataToProcess.length < audioSettingsModel.sampleSize) {
      try {
        PacketEvent event = _queue.removeAt(0);
        dataToProcess.addAll(event.packet);
      } catch (_) {
        AppLogger().log(message: 'Queue is empty', logLevel: LogLevel.debug);
      }
    }
    List<double> data = dataToProcess.sublist(0, audioSettingsModel.sampleSize);
    List<double> remainigData = dataToProcess.sublist(audioSettingsModel.sampleSize);
    _queue.insert(0, RemainingPacketEvent(remainigData));
    List<DecodedFrequency> frequencies = _translateSampleToFrequency(data);
    _decodeFrequencies(frequencies);
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    endOffset = frameModel.getTransferWavLength(audioSettingsModel);
  }

  void _finishDecoding() {
    AppLogger().log(message: 'Finished decoding', logLevel: LogLevel.debug);
    onDecodingCompleted();
  }

  List<DecodedFrequency> _translateSampleToFrequency(List<double> sample) {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    return List<DecodedFrequency>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequency(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
  }

  void _decodeFrequencies(List<DecodedFrequency> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequency frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    frameModelDecoder.addBinaries(binaries);
  }

  void recordingStatus({required bool status}) {
    recordingBool = status;
  }
}
