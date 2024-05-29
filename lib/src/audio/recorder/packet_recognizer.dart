import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/correlation/frequency_correlation_calculator.dart';
import 'package:mrumru/src/audio/recorder/correlation/index_correlation_calculator.dart';
import 'package:mrumru/src/audio/recorder/queue/events/received_packet_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/remaining_packet_event.dart';
import 'package:mrumru/src/audio/recorder/queue/packet_event_queue.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/shared/models/decoded_frequency_model.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class PacketRecognizer {
  final Completer<bool> _decodingCompleter = Completer<bool>();
  final PacketEventQueue _packetsQueue = PacketEventQueue();

  final AudioSettingsModel audioSettingsModel;
  final VoidCallback onDecodingCompleted;
  late final FrameModelDecoder _frameModelDecoder;

  bool _recordingBool = false;
  int? _startOffset;
  int? _endOffset;

  PacketRecognizer({
    required this.audioSettingsModel,
    required this.onDecodingCompleted,
    required FrameSettingsModel frameSettingsModel,
    ValueChanged<FrameModel>? onFrameDecoded,
  }) {
    _frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: _handleFirstFrameDecoded,
      onLastFrameDecoded: (_) => stopRecording(),
      onFrameDecoded: onFrameDecoded,
    );
  }

  FrameCollectionModel get decodedContent => _frameModelDecoder.decodedContent;

  Future<void> startDecoding() async {
    _recordingBool = true;
    while (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize) || _recordingBool) {
      if (_startOffset == null) {
        await _tryFindStartOffset();
      } else {
        await _tryProcessWave();
      }
    }

    _decodingCompleter.complete(true);
  }

  void addPacket(ReceivedPacketEvent packet) {
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packet);
  }

  Future<void> stopRecording() async {
    _recordingBool = false;
    await _decodingCompleter.future;
    onDecodingCompleted();
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    _endOffset = frameModel.getTransferWavLength(audioSettingsModel);
    AppLogger().log(message: 'End offset found: $_endOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryFindStartOffset() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.maxStartOffset)) {
      await _findStartOffset();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _findStartOffset() async {
    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.maxStartOffset);
    _startOffset = await compute(_computeStartOffset, <dynamic>[waveToProcess, audioSettingsModel]);

    List<double> remainingData = waveToProcess.sublist(_startOffset!);
    _packetsQueue.push(RemainingPacketEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $_startOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryProcessWave() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize)) {
      await _processWave();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _processWave() async {
    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.sampleSize);
    List<DecodedFrequencyModel> frequencies = await _translateSampleToFrequency(waveToProcess);
    _decodeFrequencies(frequencies);
   }

  Future<List<DecodedFrequencyModel>> _translateSampleToFrequency(List<double> sample) async {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    List<DecodedFrequencyModel> decodedFrequencies = List<DecodedFrequencyModel>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequencyModel(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
    return decodedFrequencies;
  }

  void _decodeFrequencies(List<DecodedFrequencyModel> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequencyModel frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    _frameModelDecoder.addBinaries(binaries);
  }
}

Future<int> _computeStartOffset(List<dynamic> props) async {
  List<double> wave = props[0] as List<double>;
  AudioSettingsModel audioSettingsModel = props[1] as AudioSettingsModel;

  IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
  return correlationCalculator.findBestIndex(wave, audioSettingsModel.startFrequencies);
}
