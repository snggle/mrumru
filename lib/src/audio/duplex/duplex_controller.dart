import 'dart:async';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/duplex/duplex_emitter_controller.dart';
import 'package:mrumru/src/audio/duplex/duplex_recorder_controller.dart';

/// A class to control the duplex audio communication.
class DuplexController {
  /// The controller for emitting audio samples.
  final DuplexEmitterController _duplexEmitterController;

  /// The controller for recording audio samples.
  final DuplexRecorderController _duplexRecorderController;

  /// The notifier for the duplex controller.
  final DuplexControllerNotifier _duplexControllerNotifier;

  /// A flag to check if the communication is completed.
  bool _completedBool = false;

  /// Creates an instance of [DuplexController].
  DuplexController({
    required AudioSettingsModel audioSettingsModel,
    required DuplexControllerNotifier duplexControllerNotifier,
  })  : _duplexControllerNotifier = duplexControllerNotifier,
        _duplexEmitterController = DuplexEmitterController(
          audioSettingsModel: audioSettingsModel,
        ),
        _duplexRecorderController = DuplexRecorderController(
          audioSettingsModel: audioSettingsModel,
        );

  /// Starts communication by sending a message.
  Future<void> send(String data) async {
    _duplexControllerNotifier.onEmitMessage?.call(data);
    await _duplexEmitterController.emit(data);
    await _performDuplexOperation(receive);
  }

  /// Starts communication by receiving a message.
  Future<void> receive() async {
    FrameCollectionModel frameCollectionModel = await _duplexRecorderController.listen();
    String data = frameCollectionModel.mergedRawData;
    _duplexControllerNotifier.onMessageReceived?.call(data);
    await _performDuplexOperation(() => _handleDataReceived(data));
  }

  /// Kills the duplex controllers.
  Future<void> kill() async {
    _completedBool = true;
    _duplexControllerNotifier.onMessageReceived?.call('');
    await _duplexEmitterController.kill();
    await _duplexRecorderController.kill();
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

  /// Performs a duplex operation if the communication is not completed.
  Future<void> _performDuplexOperation<T>(Future<void> Function() operation) async {
    if (_completedBool) {
      return;
    }
    await operation();
  }
}
