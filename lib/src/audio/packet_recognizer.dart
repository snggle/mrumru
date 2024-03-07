import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/correlation/frequency_correlation_calculator.dart';
import 'package:mrumru/src/audio/correlation/index_correlation_calculator.dart';
import 'package:mrumru/src/audio/packet_event.dart';
import 'package:mrumru/src/audio/packets_queue.dart';
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
  final PacketsQueue _packetsQueue = PacketsQueue();
  int? startOffset;
  int? endOffset;
  Completer<bool> decodingCompleter = Completer<bool>();

  PacketRecognizer({
    required this.audioSettingsModel,
    required this.onDecodingCompleted,
    required FrameSettingsModel frameSettingsModel,
    ValueChanged<FrameModel>? onFrameDecoded,
  })  : startFrequencies = audioSettingsModel.startFrequencies,
        maxStartOffset = (7 * audioSettingsModel.sampleSize).toInt() {
    frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: _handleFirstFrameDecoded,
      onLastFrameDecoded: (_) => stopRecording(),
      onFrameDecoded: onFrameDecoded,
    );
  }

  bool recording = false;

  void addPacket(ReceivedPacketEvent packet) {
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packet);
  }

  FrameCollectionModel get decodedContent => frameModelDecoder.decodedContent;

  Future<void> startDecoding() async {
    recording = true;

    while (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize) || recording ) {
      if (startOffset == null) {
        if (_packetsQueue.isLongerThan(maxStartOffset)) {
          await _findStartOffset();
        } else {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      } else {
        if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize)) {
          await _processData();
        } else {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      }
    }

    decodingCompleter.complete(true);
  }

  Future<void> stopRecording() async {
    recording = false;
    await decodingCompleter.future;
    onDecodingCompleted();
  }

  Future<void> _findStartOffset() async {
    List<double> dataToProcess = await _packetsQueue.readSingle(maxStartOffset);

    startOffset = await compute(computeStartOffset, <dynamic>[dataToProcess, audioSettingsModel]);

    List<double> remainingData = dataToProcess.sublist(startOffset!);
    _packetsQueue.push(RemainingPacketEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $startOffset', logLevel: LogLevel.debug);
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    endOffset = frameModel.getTransferWavLength(audioSettingsModel);
    AppLogger().log(message: 'End offset found: $endOffset', logLevel: LogLevel.debug);
  }

  Future<void> _processData() async {
    List<double> dataToProcess = await _packetsQueue.readSingle(audioSettingsModel.sampleSize);
    List<DecodedFrequency> frequencies = await _translateSampleToFrequency(dataToProcess);
    _decodeFrequencies(frequencies);
  }

  void _decodeFrequencies(List<DecodedFrequency> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequency frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    frameModelDecoder.addBinaries(binaries);
  }

  Future<List<DecodedFrequency>> _translateSampleToFrequency(List<double> sample) async {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    List<DecodedFrequency> decodedFrequencies = List<DecodedFrequency>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequency(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
    return decodedFrequencies;
  }
}


int computeStartOffset(List<dynamic> props) {
  List<double> wave = props[0] as List<double>;
  AudioSettingsModel audioSettingsModel = props[1] as AudioSettingsModel;

  IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
  return correlationCalculator.findBestIndex(wave, audioSettingsModel.startFrequencies);
}