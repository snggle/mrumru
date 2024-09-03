import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mp_audio_stream/mp_audio_stream.dart';
import 'package:mrumru/src/audio/generator/sink/i_audio_sink.dart';

/// The [AudioStreamSink] class provides functionalities to initialize the audio stream,
/// push audio samples to it, and uninitialize the stream when done.
class AudioStreamSink implements IAudioSink {
  /// A completer to notify when the stream is done.
  final Completer<void> _streamCompleter = Completer<void>();

  /// The audio stream used to push audio samples.
  final AudioStream _audioStream;

  bool completedBool = false;

  /// The timer used to stop the audio stream.
  Timer? timer;

  /// Creates an instance of [AudioStreamSink] and initializes the [_audioStream].
  AudioStreamSink() : _audioStream = getAudioStream();

  /// Initializes the audio stream with the given [transferDuration] and [sampleRate].
  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    if (completedBool) {
      throw Exception('AudioStreamSink has been completed and cannot be re-initialized');
    }
    _audioStream.init(
      channels: 1,
      bufferMilliSec: transferDuration.inMilliseconds,
      sampleRate: sampleRate,
    );
    timer = Timer(transferDuration, kill);
  }

  /// This method adds the given [sample] to the audio stream.
  @override
  Future<void> pushSample(Float32List sample) async {
    _audioStream.push(sample);
  }

  /// Notifies that all samples have been created.
  @override
  Future<void> notifyAllSamplesCreated() async {}

  /// This method stops the audio stream and releases any resources it holds.
  @override
  Future<void> kill() async {
    if (completedBool == false) {
      completedBool = true;
      timer?.cancel();
      _audioStream.uninit();
      _notifySinkCompleted();
    }
  }

  /// Returns asynchronous method which is completed after audio stream has been completed
  @override
  Future<void> get future => _streamCompleter.future;

  /// Notifies that the audio stream has been completed
  void _notifySinkCompleted() {
    if (_streamCompleter.isCompleted == false) {
      _streamCompleter.complete();
    }
  }
}
