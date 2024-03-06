import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/correlation/frequency_correlation_calculator.dart';
import 'package:mrumru/src/audio/correlation/index_correlation_calculator.dart';
import 'package:mrumru/src/audio/packet_event.dart';
import 'package:mrumru/src/audio/packets_queue.dart';
import 'package:mrumru/src/audio/recording_status.dart';
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
  ValueNotifier<RecordingStatus> recordingStatus = ValueNotifier<RecordingStatus>(RecordingStatus.offline);
  Completer<bool> decodingCompleter = Completer<bool>();

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
      onLastFrameDecoded: (_) => onDecodingCompleted(),
      onFrameDecoded: onFrameDecoded,
    );
    recordingStatus.addListener(() {
      if (recordingStatus.value == RecordingStatus.onAir) {
        _startDecoding();
      }
    });
  }

  bool firstPacket = true;

  void addPacket(ReceivedPacketEvent packet) {
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packet);
  }

  FrameCollectionModel get decodedContent => frameModelDecoder.decodedContent;

  void updateRecordingStatus(RecordingStatus recordingStatus) {
    this.recordingStatus.value = recordingStatus;
  }

  void _decodeFrequencies(List<DecodedFrequency> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequency frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    frameModelDecoder.addBinaries(binaries);
  }

  Future<void> _findStartOffset() async {
    List<double> dataToProcess = await _packetsQueue.readWave(maxStartOffset);

    IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    startOffset = correlationCalculator.findBestIndex(dataToProcess, startFrequencies);

    List<double> remainingData = dataToProcess.sublist(startOffset!);
    _packetsQueue.push(RemainingPacketEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $startOffset', logLevel: LogLevel.debug);
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    endOffset = frameModel.getTransferWavLength(audioSettingsModel);
  }

  Future<void> _startDecoding() async {
    do {
      if (startOffset == null) {
        if (_packetsQueue.isLongerThan(maxStartOffset)) {
          await _findStartOffset();
        }
      } else {
        if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize)) {
          await _processData();
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    } while (_packetsQueue.isNotEmpty || recordingStatus.value == RecordingStatus.onAir);

    decodingCompleter.complete(true);
  }

  Future<void> _processData() async {
    List<double> dataToProcess = await _packetsQueue.readWave(audioSettingsModel.sampleSize);

    List<DecodedFrequency> frequencies = await _translateSampleToFrequency(dataToProcess);
    _decodeFrequencies(frequencies);
  }

  Future<List<DecodedFrequency>> _translateSampleToFrequency(List<double> sample) async {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    return List<DecodedFrequency>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequency(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
  }
}
