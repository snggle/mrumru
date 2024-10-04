import 'dart:async';
import 'package:mrumru/mrumru.dart';

/// Controls the duplex audio recording process.
class DuplexRecorderController {
  /// Settings for audio and frame models used in the recording process.
  final AudioSettingsModel _audioSettingsModel;

  /// The completer for the recorder controller.
  Completer<FrameCollectionModel> _recorderCompleter = Completer<FrameCollectionModel>();

  /// The audio recorder controller for recording audio samples.
  AudioRecorderController? _audioRecorderController;

  /// Creates a new instance of [DuplexRecorderController].
  DuplexRecorderController({
    required AudioSettingsModel audioSettingsModel,
  })  : _audioSettingsModel = audioSettingsModel;

  /// Listens for audio samples and returns the received data.
  Future<FrameCollectionModel> listen() async {
    _initializeAudioRecorder();
    await _audioRecorderController!.startRecording();
    FrameCollectionModel frameCollectionModel = await _recorderCompleter.future;
    await kill();
    return frameCollectionModel;
  }

  /// Kills the audio recorder controller.
  Future<void> kill() async {
    _audioRecorderController?.stopRecording();
    await _recorderCompleter.future;
    _audioRecorderController = null;
    _recorderCompleter = Completer<FrameCollectionModel>();
  }

  /// Initializes the audio recorder controller for recording audio samples.
  void _initializeAudioRecorder() {
    _recorderCompleter = Completer<FrameCollectionModel>();
    _audioRecorderController = AudioRecorderController(
      audioSettingsModel: _audioSettingsModel,
      onRecordingCompleted: _handleRecordingCompleted,
      onFrameReceived: (AFrameBase frameModel) {},
    );
  }

  /// Handles the recording completion and completes the completer with the received data.
  void _handleRecordingCompleted(FrameCollectionModel frameCollectionModel) {
    _recorderCompleter.complete(frameCollectionModel);
  }
}
