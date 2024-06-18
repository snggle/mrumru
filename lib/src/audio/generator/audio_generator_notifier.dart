import 'dart:typed_data';

typedef BinaryCreatedCallback = void Function(String binary);
typedef FrequenciesCreatedCallback = void Function(List<List<int>> frequencies);
typedef SampleCreatedCallback = void Function(Float32List sample);

/// A class to notify about various events during audio generation.
class AudioGeneratorNotifier {
  /// Callback for when binary data is created.
  final BinaryCreatedCallback? onBinaryCreated;

  /// Callback for when frequencies are created.
  final FrequenciesCreatedCallback? onFrequenciesCreated;

  /// Callback for when an audio sample is created.
  final SampleCreatedCallback? onSampleCreated;

  /// Creates an instance of [AudioGeneratorNotifier].
  AudioGeneratorNotifier({
    this.onBinaryCreated,
    this.onFrequenciesCreated,
    this.onSampleCreated,
  });
}
