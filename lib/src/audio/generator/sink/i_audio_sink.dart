import 'dart:async';
import 'dart:typed_data';

/// The [IAudioSink] interface defines the methods required for an audio sink,
/// including initialization, pushing samples, notifying when all samples are created,
/// and terminating the sink.
abstract interface class IAudioSink {
  /// Initializes the audio sink with the given [transferDuration] and [sampleRate].
  /// This method sets up the necessary configurations for the audio sink.
  Future<void> init(Duration transferDuration, int sampleRate);

  /// This method adds the given [sample] to the audio sink.
  Future<void> pushSample(Float32List sample);

  /// This method is called when all audio samples have been pushed to the sink.
  Future<void> notifyAllSamplesCreated();

  /// This method stops the audio sink and cleans up any resources.
  Future<void> kill();

  /// Returns asynchronous method which is completed after sink is finished.
  Future<void> get future;
}
