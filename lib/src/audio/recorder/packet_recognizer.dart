import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/correlation/start_index_correlation_calculator.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_remaining_event.dart';
import 'package:mrumru/src/audio/recorder/queue/packet_event_queue.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

class PacketRecognizer {
  late Completer<bool> _processLoopCompleter;
  late FrameCollectionModel frameCollectionModel;

  final PacketEventQueue _packetsQueue = PacketEventQueue();
  final AudioSettingsModel audioSettingsModel;
  final ValueChanged<FrameCollectionModel> onDecodingCompleted;

  late final FrameModelDecoder _frameModelDecoder;

  static const Duration _nextActionWaitingDuration = Duration(milliseconds: 100);

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

  Future<void> startDecoding() async {
    _processLoopCompleter = Completer<bool>();
    _recordingBool = true;

    while (_recordingBool) {
      if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize) == false) {
        await Future<void>.delayed(_nextActionWaitingDuration);
        continue;
      }

      if (_startOffset == null) {
        await _tryFindStartOffset();
      } else {
        await _tryProcessWave();
      }
    }

    _processLoopCompleter.complete(true);
  }

  void addPacket(PacketReceivedEvent packetReceivedEvent) {
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packetReceivedEvent);
  }

  Future<void> stopRecording() async {
    _recordingBool = false;
    await _processLoopCompleter.future;
    frameCollectionModel = _frameModelDecoder.decodedContent;
    AppLogger().log(message: 'Decoded frames count: ${frameCollectionModel.frames.length}', logLevel: LogLevel.debug);
    FrameCollectionModel copiedFrameCollectionModel = FrameCollectionModel(List<FrameModel>.from(frameCollectionModel.frames.map((FrameModel frame) => frame)));
    onDecodingCompleted(copiedFrameCollectionModel);
    _clear();
  }

  void _clear() {
    _packetsQueue.clear();
    _frameModelDecoder.clear();
    _startOffset = null;
    _endOffset = null;
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    _endOffset = frameModel.calculateTransferWavLength(audioSettingsModel);
    AppLogger().log(message: 'End offset found: $_endOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryFindStartOffset() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.maxStartOffset)) {
      await _findStartOffset();
    } else {
      await Future<void>.delayed(_nextActionWaitingDuration);
    }
  }

  Future<void> _findStartOffset() async {
    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.maxStartOffset);
    _startOffset = await compute(_computeStartOffset, <dynamic>[waveToProcess, audioSettingsModel]);

    List<double> remainingData = waveToProcess.sublist(_startOffset!);
    _packetsQueue.push(PacketRemainingEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $_startOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryProcessWave() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize)) {
      await _processSampleWave();
    } else {
      await Future<void>.delayed(_nextActionWaitingDuration);
    }
  }

  Future<void> _processSampleWave() async {
    List<double> sampleWave = await _packetsQueue.readWave(audioSettingsModel.sampleSize);
    SampleModel sampleModel = SampleModel.fromWave(sampleWave, audioSettingsModel);
    _frameModelDecoder.addBinaries(<String>[sampleModel.calcBinary()]);
  }
}

Future<int> _computeStartOffset(List<dynamic> props) async {
  List<double> wave = props[0] as List<double>;
  AudioSettingsModel audioSettingsModel = props[1] as AudioSettingsModel;

  StartIndexCorrelationCalculator startIndexCorrelationCalculator = StartIndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
  return startIndexCorrelationCalculator.findIndexWithHighestCorrelation(wave, audioSettingsModel.startFrequencies);
}
