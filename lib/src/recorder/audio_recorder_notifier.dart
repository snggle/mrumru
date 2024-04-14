import 'dart:typed_data';

typedef SampleReceivedCallback = void Function(List<double> sample);
typedef DecodingCompleteCallback = void Function();

class AudioRecorderNotifier {
  final SampleReceivedCallback onSampleReceived;
  final DecodingCompleteCallback onDecodingCompleted;

  AudioRecorderNotifier({
    required this.onSampleReceived,
    required this.onDecodingCompleted,
  });
}
