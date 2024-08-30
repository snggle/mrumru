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
  static const Duration _nextActionWaitingDuration = Duration(milliseconds: 100);

  final PacketEventQueue _packetsQueue = PacketEventQueue();
  final AudioSettingsModel _audioSettingsModel;
  final ValueChanged<FrameCollectionModel> _onDecodingCompleted;

  late final FrameModelDecoder _frameModelDecoder;
  late Completer<bool> _processLoopCompleter;

  bool _recordingBool = false;
  int? _startOffset;
  int? _endOffset;

  PacketRecognizer({
    required AudioSettingsModel audioSettingsModel,
    required void Function(FrameCollectionModel) onDecodingCompleted,
    required FrameSettingsModel frameSettingsModel,
    ValueChanged<FrameModel>? onFrameDecoded,
  })  : _audioSettingsModel = audioSettingsModel,
        _onDecodingCompleted = onDecodingCompleted {
    _frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: _handleFirstFrameDecoded,
      onLastFrameDecoded: (_) => stopRecording(),
      onFrameDecoded: onFrameDecoded,
    );
  }

  FrameCollectionModel get decodedContent => _frameModelDecoder.decodedContent;

  Future<void> startDecoding() async {
    _processLoopCompleter = Completer<bool>();
    _recordingBool = true;

    while (_recordingBool) {
      if (_packetsQueue.isLongerThan(_audioSettingsModel.sampleSize) == false) {
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
    _onDecodingCompleted(decodedContent);
    _clear();
  }

  void _clear() {
    _packetsQueue.clear();
    _frameModelDecoder.clear();
    _startOffset = null;
    _endOffset = null;
  }

  void _handleFirstFrameDecoded(FrameModel frameModel) {
    _endOffset = frameModel.calculateTransferWavLength(_audioSettingsModel);
    AppLogger().log(message: 'End offset found: $_endOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryFindStartOffset() async {
    if (_packetsQueue.isLongerThan(_audioSettingsModel.maxStartOffset)) {
      await _findStartOffset();
    } else {
      await Future<void>.delayed(_nextActionWaitingDuration);
    }
  }

  Future<void> _findStartOffset() async {
    List<double> waveToProcess = await _packetsQueue.readWave(_audioSettingsModel.maxStartOffset);
    _startOffset = await compute(_computeStartOffset, <dynamic>[waveToProcess, _audioSettingsModel]);

    List<double> remainingData = waveToProcess.sublist(_startOffset!);
    _packetsQueue.push(PacketRemainingEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $_startOffset', logLevel: LogLevel.debug);
  }

  Future<void> _tryProcessWave() async {
    if (_packetsQueue.isLongerThan(_audioSettingsModel.sampleSize)) {
      await _processSampleWave();
    } else {
      await Future<void>.delayed(_nextActionWaitingDuration);
    }
  }

  Future<void> _processSampleWave() async {
    List<double> sampleWave = await _packetsQueue.readWave(_audioSettingsModel.sampleSize);
    SampleModel sampleModel = SampleModel.fromWave(sampleWave, _audioSettingsModel);
    _frameModelDecoder.addBinaries(<String>[sampleModel.calcBinary()]);
  }
}

Future<int> _computeStartOffset(List<dynamic> props) async {
  List<double> wave = props[0] as List<double>;
  AudioSettingsModel audioSettingsModel = props[1] as AudioSettingsModel;

  StartIndexCorrelationCalculator startIndexCorrelationCalculator = StartIndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);
  return startIndexCorrelationCalculator.findIndexWithHighestCorrelation(wave, audioSettingsModel.startFrequencies);
}
