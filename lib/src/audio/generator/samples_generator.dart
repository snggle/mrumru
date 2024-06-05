import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/generator/samples_generator_thread.dart';
import 'package:stream_isolate/stream_isolate.dart';

/// The [SamplesGenerator] class provides functionalities to build audio samples
/// from frequencies using the provided [AudioSettingsModel].
class SamplesGenerator {
  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// A nullable instance of [StreamIsolate].
  StreamIsolate<Float32List, void>? _streamIsolate;

  /// Creates an instance of [SamplesGenerator].
  SamplesGenerator(this._audioSettingsModel);

  /// This method spawns an isolate and builds audio samples from the given list of [frequencies]
  /// and calls [onSampleCreated] for each generated sample.
  Future<void> buildSamples({required List<List<int>> frequencies, required SampleCreatedCallback onSampleCreated}) async {
    _streamIsolate = await StreamIsolate.spawn(() {
      return SamplesGeneratorThread(_audioSettingsModel).parseFrequenciesToSamples(frequencies);
    });
    await for (Float32List sample in _streamIsolate!.stream) {
      onSampleCreated(sample);
    }
    _streamIsolate = null;
  }

  /// This method checks if the [_streamIsolate] is not null and, if so,
  /// calls the [kill] method on the [_streamIsolate] to terminate it.
  void kill() {
    _streamIsolate?.kill();
  }
}
