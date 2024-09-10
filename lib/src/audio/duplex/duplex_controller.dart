import 'dart:async';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/duplex/duplex_emitter_controller.dart';
import 'package:mrumru/src/audio/duplex/duplex_processor.dart';
import 'package:mrumru/src/audio/duplex/duplex_recorder_controller.dart';

class DuplexController {
  final DuplexEmitterController duplexEmitterController;
  final DuplexRecorderController duplexRecorderController;
  final DuplexControllerNotifier duplexControllerNotifier;
  final DuplexProcessor duplexProcessor = DuplexProcessor();

  bool _isStoppedBool = false;

  DuplexController({
    required AudioSettingsModel audioSettingsModel,
    required FrameSettingsModel frameSettingsModel,
    required this.duplexControllerNotifier,
  })  : duplexEmitterController = DuplexEmitterController(
    audioSettingsModel: audioSettingsModel,
    frameSettingsModel: frameSettingsModel,
  ),
        duplexRecorderController = DuplexRecorderController(
          audioSettingsModel: audioSettingsModel,
          frameSettingsModel: frameSettingsModel,
        );

  Future<void> send(String data, DuplexFlag flag) async {
    if (_isStoppedBool) {
      return;
    }
    await duplexEmitterController.emit(data, flag);
    duplexControllerNotifier.onEmitMessage?.call(data);

    if (flag == DuplexFlag.single || _isStoppedBool) {
      return;
    }

    await receive();
  }

  Future<void> receive() async {
    if (_isStoppedBool) {
      return;
    }

    FrameCollectionModel frameCollectionModel = await duplexRecorderController.listen();
    String data = frameCollectionModel.mergedRawData;
    DuplexFlag flag = _getDuplexFlagFromFrames(frameCollectionModel);

    duplexControllerNotifier.onMessageReceived?.call(data);

    String missingFrames = duplexProcessor.handleMissingData(frameCollectionModel);

    if (missingFrames.isNotEmpty) {
      await send(missingFrames, DuplexFlag.missingData);
    }

    await _handleMessageBasedOnFlag(data, flag);
  }

  DuplexFlag _getDuplexFlagFromFrames(FrameCollectionModel frameCollectionModel) {
    if (frameCollectionModel.frames.isNotEmpty) {
      return frameCollectionModel.frames.first.duplexFlag;
    }
    return DuplexFlag.unknown;
  }

  Future<void> _handleMessageBasedOnFlag(String data, DuplexFlag flag) async {
    switch (flag) {
      case DuplexFlag.single:
        await duplexProcessor.handleSingleMessage(data);
        break;
      case DuplexFlag.requestResponse:
        await duplexProcessor.handleRequestResponseMessage(data, this);
        break;
      case DuplexFlag.noData:
        await duplexProcessor.handleNoDataMessage();
        break;
      case DuplexFlag.unknown:
      default:
        await duplexProcessor.handleUnknownFlag();
        break;
    }
  }

  Future<void> kill() async {
    _isStoppedBool = true;
    duplexControllerNotifier.onMessageReceived?.call('');
    await duplexEmitterController.kill();
    await duplexRecorderController.kill();
  }
}
