import 'dart:typed_data';

abstract interface class IAudioSink {
  Future<void> init(Duration transferDuration, int sampleRate);

  Future<void> pushSample(Float32List sample);

  Future<void> finish();
}