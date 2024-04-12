import 'package:mrumru/mrumru.dart';

typedef BinaryCreatedCallback = void Function(String binary);
typedef FrequenciesCreatedCallback = void Function(List<List<int>> frequencies);

class AudioEmitterNotifier {
  final BinaryCreatedCallback? onBinaryCreated;
  final FrequenciesCreatedCallback? onFrequenciesCreated;
  final SampleCreatedCallback? onSampleCreated;

  AudioEmitterNotifier({
    this.onBinaryCreated,
    this.onFrequenciesCreated,
    this.onSampleCreated,
  });
}
