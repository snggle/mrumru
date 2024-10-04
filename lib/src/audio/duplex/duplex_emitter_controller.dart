import 'package:mrumru/mrumru.dart';

/// A class to control the duplex audio emission.
class DuplexEmitterController {
  /// The audio settings model for audio configuration and frame configuration for frame structure.
  final AudioSettingsModel _audioSettingsModel;

  /// The audio generator for generating audio samples.
  AudioGenerator? _audioGenerator;

  /// The audio stream sink for passing audio samples to a stream.
  AudioStreamSink? _audioStreamSink;

  /// Creates an instance of [DuplexEmitterController].
  DuplexEmitterController({
    required AudioSettingsModel audioSettingsModel,
  })  :_audioSettingsModel = audioSettingsModel;

  /// Emits audio samples from provided data.
  Future<void> emit(String data) async {
    _initializeAudioGenerator();
    await _audioGenerator!.generate(data);
    await _audioStreamSink!.future;
    await kill();
  }

  /// Kills the audio generator and audio stream sink. Note that always need to double close the sink to avoid lagging and desynchronisation duplex.
  Future<void> kill() async {
    await _audioGenerator?.stop();
    _audioGenerator = null;
    _audioStreamSink = null;
  }

  /// Initializes the audio generator and audio stream sink for emitting audio samples.
  void _initializeAudioGenerator() {
    _audioStreamSink = AudioStreamSink();
    _audioGenerator = AudioGenerator(
      audioSink: _audioStreamSink!,
      audioSettingsModel: _audioSettingsModel,
    );
  }
}
