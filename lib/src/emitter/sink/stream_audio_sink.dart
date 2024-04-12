import 'package:flutter/foundation.dart';
import 'package:mp_audio_stream/mp_audio_stream.dart';
import 'package:mrumru/mrumru.dart';

class StreamAudioSink implements IAudioSink {
  final AudioStream audioStream;

  StreamAudioSink() : audioStream = getAudioStream();

  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    audioStream.init(
      channels: 1,
      bufferMilliSec: transferDuration.inMilliseconds,
      sampleRate: sampleRate,
    );
  }

  @override
  Future<void> pushSample(Float32List sample) async {
    audioStream.push(sample);
  }

  @override
  Future<void> finish() async {
    audioStream.uninit();
  }
}
