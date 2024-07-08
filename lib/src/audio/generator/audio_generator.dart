import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/generator/fsk_encoder.dart';
import 'package:mrumru/src/audio/generator/samples_generator.dart';
import 'package:mrumru/src/frame/frame_model_builder.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

/// A class that generates audio signals from text messages using Frequency Shift Keying (FSK).
class AudioGenerator {
  /// The sink where the generated audio will be outputted.
  final IAudioSink _audioSink;

  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// The settings model for frame configuration.
  final FrameSettingsModel _frameSettingsModel;

  /// Optional notifier for audio generation events.
  final AudioGeneratorNotifier? _audioGeneratorNotifier;

  /// The samples generator to build audio samples from frequencies.
  final SamplesGenerator _samplesGenerator;

  /// Creates an instance of [AudioGenerator].
  AudioGenerator({
    required IAudioSink audioSink,
    required AudioSettingsModel audioSettingsModel,
    required FrameSettingsModel frameSettingsModel,
    AudioGeneratorNotifier? audioGeneratorNotifier,
  })  : _audioGeneratorNotifier = audioGeneratorNotifier,
        _frameSettingsModel = frameSettingsModel,
        _audioSettingsModel = audioSettingsModel,
        _audioSink = audioSink,
        _samplesGenerator = SamplesGenerator(audioSettingsModel);

  /// This method encodes the text message into binary, converts the binary data
  /// into frequencies using FSK, and then builds and pushes audio samples to the sink.
  Future<void> generate(String message) async {
    FskEncoder fskEncoder = FskEncoder(_audioSettingsModel);

    String binaryData = _parseTextToBinary(message);
    _audioGeneratorNotifier?.onBinaryCreated?.call(binaryData);

    List<List<int>> frequencies = fskEncoder.buildFrequencies(binaryData);
    _audioGeneratorNotifier?.onFrequenciesCreated?.call(frequencies);

    Duration transferDuration = Duration(milliseconds: ((frequencies.length + 2) * _audioSettingsModel.symbolDuration.inMilliseconds).toInt());
    await _audioSink.init(transferDuration, _audioSettingsModel.sampleRate);
    _startBuildingSamples(frequencies);
  }

  /// Stops the audio generation process and kills the audio sink.
  Future<void> stop() async {
    await _audioSink.kill();
    _samplesGenerator.kill();
  }

  /// This method builds a frame collection from the text and converts it into a binary string.
  String _parseTextToBinary(String text) {
    FrameModelBuilder frameModelBuilder = FrameModelBuilder(frameSettingsModel: _frameSettingsModel);
    FrameCollectionModel frameCollectionModel = frameModelBuilder.buildFrameCollection(text);
    String binaryData = frameCollectionModel.mergedBinaryFrames;
    return _fillBinaryWithZeros(binaryData);
  }

  /// Fills the binary data with zeros to make its length a multiple of the required chunk size.
  String _fillBinaryWithZeros(String binaryData) {
    int divider = _audioSettingsModel.bitsPerFrequency * _audioSettingsModel.chunksCount;
    int remainder = binaryData.length % divider;
    int zerosToAdd = remainder == 0 ? 0 : divider - remainder;
    return binaryData + List<String>.filled(zerosToAdd, '0').join('');
  }

  /// This method uses a [SamplesGenerator] to convert frequencies into audio samples
  /// and pushes each sample to the audio sink.
  void _startBuildingSamples(List<List<int>> frequencies) {
    _samplesGenerator
        .buildSamples(
        frequencies: frequencies,
        onSampleCreated: (Float32List sample) {
          // print('pushing sample');
          _audioSink.pushSample(sample);
          _audioGeneratorNotifier?.onSampleCreated?.call(sample);
        },
        symbolDurationCalculator: _audioSettingsModel.calculateSymbolDuration
    )
        .then((_) => _audioSink.notifyAllSamplesCreated());
  }
}
