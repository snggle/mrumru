import 'dart:async';
import 'dart:typed_data';

import 'package:mrumru/src/audio/generator/sink/i_audio_sink.dart';

/// This class provides functionalities to initialize, push samples, notify all
/// samples created, and kill multiple [IAudioSink] instances simultaneously.
class AudioMultiSink implements IAudioSink {
  /// A list of audio sinks to manage.
  final List<IAudioSink> _sinks;

  /// Creates an instance of [AudioMultiSink].
  AudioMultiSink(this._sinks);

  /// Initializes all the audio sinks with the given [transferDuration] and [sampleRate].
  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    for (IAudioSink sink in _sinks) {
      await sink.init(transferDuration, sampleRate);
    }
  }

  /// This method adds the given [sample] to each sink in the list of sinks.
  @override
  Future<void> pushSample(Float32List sample) async {
    for (IAudioSink sink in _sinks) {
      await sink.pushSample(sample);
    }
  }

  /// Notifies that all samples have been created and triggers the process for all sinks.
  @override
  Future<void> notifyAllSamplesCreated() async {
    for (IAudioSink sink in _sinks) {
      await sink.notifyAllSamplesCreated();
    }
  }

  /// Kills the audio sink process for all sinks by deleting their data and clearing the samples.
  @override
  Future<void> kill() async {
    for (IAudioSink sink in _sinks) {
      await sink.kill();
    }
  }

  /// This method call sinks completer and complete all the sinks work
  @override
  Future<void> get future => Future.wait(_sinks.map((IAudioSink sink) => sink.future));
}
