import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';

class AudioEmitter {
  final IAudioSink audioSink;
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;
  final AudioEmitterNotifier? audioEmitterNotifier;

  AudioEmitter({
    required this.audioSink,
    required this.audioSettingsModel,
    required this.frameSettingsModel,
    this.audioEmitterNotifier,
  });

  void play(String message) {
    FskEncoder fskEncoder = FskEncoder(audioSettingsModel);
    SampleGenerator sampleGenerator = SampleGenerator(audioSettingsModel);

    String binaryData = _parseTextToBinary(message);
    audioEmitterNotifier?.onBinaryCreated?.call(binaryData);

    List<List<int>> frequencies = fskEncoder.encodeBinaryToFrequencies(binaryData);
    audioEmitterNotifier?.onFrequenciesCreated?.call(frequencies);

    Duration transferDuration = Duration(milliseconds: ((frequencies.length + 2) * audioSettingsModel.symbolDuration.inMilliseconds).toInt());
    audioSink.init(transferDuration, audioSettingsModel.sampleRate);

    sampleGenerator.buildSamples(frequencies, (Float32List sample) {
      audioSink.pushSample(sample);
      audioEmitterNotifier?.onSampleCreated?.call(sample);
    });
  }

  void stop() {
    audioSink.finish();
  }

  String _parseTextToBinary(String text) {
    FrameModelBuilder frameModelBuilder = FrameModelBuilder(frameSettingsModel: frameSettingsModel);
    FrameCollectionModel frameCollectionModel = frameModelBuilder.buildFrameCollection(text);
    String binaryData = frameCollectionModel.mergedBinaryFrames;
    return _fillBinaryWithZeros(binaryData);
  }

  String _fillBinaryWithZeros(String binaryData) {
    int divider = audioSettingsModel.bitsPerFrequency * audioSettingsModel.chunksCount;
    int remainder = binaryData.length % divider;
    int zerosToAdd = remainder == 0 ? 0 : divider - remainder;
    return binaryData + List<String>.filled(zerosToAdd, '0').join('');
  }
}
