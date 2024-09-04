import 'dart:typed_data';

import 'package:mrumru/src/audio/generator/audio_generator_notifier.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';
import 'package:stream_isolate/stream_isolate.dart';

/// The [SamplesProcessor] class is responsible for processing the samples in a separate isolate.
/// It takes the samples list and processes them into wave.
class SamplesProcessor {
  /// The stream isolate for processing the samples.
  StreamIsolate<Float32List, void>? _streamIsolate;

  /// This method processes the samples list into wave and returns the wave samples.
  Future<void> processSamples({required List<SampleModel> samplesList, required SampleCreatedCallback onSampleCreated}) async {
    _streamIsolate = await StreamIsolate.spawn(() {
      return _processSamplesThread(List<SampleModel>.from(samplesList));
    });
    await for (Float32List sample in _streamIsolate!.stream) {
      onSampleCreated(sample);
    }
    _streamIsolate = null;
  }

  /// Kills the stream.
  void kill() {
    _streamIsolate?.close();
  }

  /// This method processes the samples list into wave.
  static Stream<Float32List> _processSamplesThread(List<SampleModel> samplesList) async* {
    for (SampleModel sampleModel in samplesList) {
      List<double> sampleWave = sampleModel.calcWave();
      yield Float32List.fromList(sampleWave);
    }
  }
}
