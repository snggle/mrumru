import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';

class AudioSinkCollection implements IAudioSink {
  final List<IAudioSink> sinks;

  AudioSinkCollection(this.sinks);

  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    for (IAudioSink sink in sinks) {
      await sink.init(transferDuration, sampleRate);
    }
  }

  @override
  Future<void> pushSample(Float32List sample) async {
    for (IAudioSink sink in sinks) {
      await sink.pushSample(sample);
    }
  }

  @override
  Future<void> finish() async {
    for (IAudioSink sink in sinks) {
      await sink.finish();
    }
  }
}
