import 'dart:async';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/duplex/duplex_emitter_controller.dart';
import 'package:mrumru/src/audio/duplex/duplex_recorder_controller.dart';
import 'package:mrumru/src/shared/utils/duplex_utils.dart';

/// A class to control the duplex audio communication.
class DuplexController {
  /// The controller for emitting audio samples.
  final DuplexEmitterController duplexEmitterController;

  /// The controller for recording audio samples.
  final DuplexRecorderController duplexRecorderController;

  /// The notifier for the duplex controller.
  final DuplexControllerNotifier duplexControllerNotifier;

  bool _isStoppedBool = false;

  /// Creates an instance of [DuplexController].
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

  /// Starts communication by sending a message with a flag.
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

  /// Starts communication by receiving a message.
  Future<void> receive() async {
    if (_isStoppedBool) {
      return;
    }

    FrameCollectionModel frameCollectionModel = await duplexRecorderController.listen();
    String data = frameCollectionModel.mergedRawData;

    DuplexFlag flag = _getDuplexFlagFromFrames(frameCollectionModel);

    duplexControllerNotifier.onMessageReceived?.call(data);
    if (flag == DuplexFlag.single) {
      return;
    } else if (!_isStoppedBool) {
      await _handleDataReceived(data);
    }
  }

  /// Odczytuje flagę DuplexFlag na podstawie danych w FrameCollectionModel.
  DuplexFlag _getDuplexFlagFromFrames(FrameCollectionModel frameCollectionModel) {
    if (frameCollectionModel.frames.isNotEmpty) {
      return frameCollectionModel.frames.first.duplexFlag;
    }
    return DuplexFlag.unknown;
  }

  /// Kills the duplex controllers.
  Future<void> kill() async {
    _isStoppedBool = true;
    duplexControllerNotifier.onMessageReceived?.call('');
    await duplexEmitterController.kill();
    await duplexRecorderController.kill();
  }

  /// Handles the received data and sends a response if needed or kills the communication if the data is empty.
  Future<void> _handleDataReceived(String receivedData) async {
    if (receivedData == 'ping') {
      await send('pong', DuplexFlag.requestResponse);
    } else if (receivedData.isNotEmpty) {
      await send(receivedData, DuplexFlag.requestResponse);
    } else {
      await kill();
    }
  }
}
