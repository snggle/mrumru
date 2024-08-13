import 'dart:async';

import 'package:mrumru/mrumru.dart';

/// A class to control the duplex audio recording.
class DuplexRecorderController {
  /// The audio settings model for audio configuration and frame configuration for frame structure.
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;

  /// The audio recorder controller for recording audio samples.
  AudioRecorderController? _audioRecorderController;

  /// The completer for the recorder controller.
  Completer<String> _recorderCompleter = Completer<String>();

  /// Creates an instance of [DuplexRecorderController].
  DuplexRecorderController({
    required this.audioSettingsModel,
    required this.frameSettingsModel,
  });

  /// Listens for audio samples and returns the received data.
  Future<String> listen() async {
    _initializeAudioRecorder();
    await _audioRecorderController!.startRecording();
    String data = await _recorderCompleter.future;
    await kill();
    return data;
  }

  /// Kills the audio recorder controller.
  Future<void> kill() async {
    _audioRecorderController?.stopRecording();
    await _recorderCompleter.future;
    _audioRecorderController = null;
    _recorderCompleter = Completer<String>();
  }

  /// Initializes the audio recorder controller for recording audio samples.
  void _initializeAudioRecorder() {
    _recorderCompleter = Completer<String>();
    _audioRecorderController = AudioRecorderController(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
      onRecordingCompleted: _handleRecordingCompleted,
      onFrameReceived: (_) {},
    );
  }

  /// Handles the recording completion and completes the completer with the received data.
  void _handleRecordingCompleted() {
    String receivedData = _audioRecorderController!.packetRecognizer.decodedContent.mergedRawData;
    _recorderCompleter.complete(receivedData);
  }
}
