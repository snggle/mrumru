import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/generator/sample_generator.dart';
import 'package:mrumru/src/audio/generator/samples_processor.dart';
import 'package:mrumru/src/frame/frame_model_builder.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';

/// A class that generates audio signals from text messages using Frequency Shift Keying (FSK).
class AudioGenerator {
  /// The sink where the generated audio will be outputted.
  final IAudioSink _audioSink;

  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// Optional notifier for audio generation events.
  final AudioGeneratorNotifier? _audioGeneratorNotifier;

  /// The sample processor to process the samples list into wave.
  final SamplesProcessor _samplesProcessor;

  /// The sample generator to build samples from binary data.
  final SampleGenerator _sampleGenerator;

  /// Creates an instance of [AudioGenerator].
  AudioGenerator({
    required IAudioSink audioSink,
    required AudioSettingsModel audioSettingsModel,
    AudioGeneratorNotifier? audioGeneratorNotifier,
  })  : _audioGeneratorNotifier = audioGeneratorNotifier,
        _audioSettingsModel = audioSettingsModel,
        _audioSink = audioSink,
        _samplesProcessor = SamplesProcessor(),
        _sampleGenerator = SampleGenerator(audioSettingsModel);

  /// This method encodes the text message into binary, converts the binary data
  /// into frequencies using FSK, and then builds and pushes audio samples to the sink.
  Future<void> generate(String message) async {
    String binaryData = _parseTextToBinary(message);
    _audioGeneratorNotifier?.onBinaryCreated?.call(binaryData);

    List<SampleModel> samplesList = _sampleGenerator.buildSamplesFromBinary(binaryData);
    _audioGeneratorNotifier?.onFrequenciesCreated?.call(samplesList);

    Duration transferDuration = Duration(milliseconds: ((samplesList.length + 2) * _audioSettingsModel.sampleDuration.inMilliseconds).toInt());
    await _audioSink.init(transferDuration, _audioSettingsModel.sampleRate);
    _startBuildingSamples(samplesList);
  }

  /// Stops the audio generation process and kills the audio sink.
  Future<void> stop() async {
    await _audioSink.kill();
    _samplesProcessor.close();
  }

  /// This method parses the text message into binary data.
  String _parseTextToBinary(String text) {
    FrameModelBuilder frameModelBuilder = FrameModelBuilder(asciiCharacterCountInFrame: 32);
    FrameCollectionModel frameCollectionModel = frameModelBuilder.buildFrameCollection(text);
    String binaryData = frameCollectionModel.mergedBinaryFrames;
    return binaryData;
  }


  /// This method uses a [SamplesProcessor] to process the samples into wave
  /// and pushes each sample to the audio sink.
  void _startBuildingSamples(List<SampleModel> samplesList) {
    _samplesProcessor
        .processSamples(
            samplesList: samplesList,
            onSampleCreated: (Float32List sample) {
              _audioSink.pushSample(sample);
              _audioGeneratorNotifier?.onSampleCreated?.call(sample);
            })
        .then((_) => _audioSink.notifyAllSamplesCreated());
  }
}
