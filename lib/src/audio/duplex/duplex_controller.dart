import 'dart:async';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/duplex/duplex_emitter_controller.dart';
import 'package:mrumru/src/audio/duplex/duplex_recorder_controller.dart';

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

  /// Starts communication by sending a message.
  Future<void> send(String data) async {
    if (_isStoppedBool) {
      return;
    }
    await duplexEmitterController.emit(data);
    duplexControllerNotifier.onEmitMessage?.call(data);
    if (_isStoppedBool == false) {
      await receive();
    }
  }

  /// Starts communication by receiving a message.
  Future<void> receive() async {
    if (_isStoppedBool) {
      return;
    }
    String data = await duplexRecorderController.listen();
    duplexControllerNotifier.onMessageReceived?.call(data);
    if (_isStoppedBool == false) {
      await _handleDataReceived(data);
    }
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
      await send('pong');
    } else if (receivedData.isNotEmpty) {
      await send(receivedData);
    } else {
      await kill();
    }
  }
}
