import 'dart:typed_data';

import 'package:wav/bytes_reader.dart';
import 'package:wav/wav.dart';

class CustomWav {
  static Wav readWithoutHeaders(Uint8List bytes) {
    BytesReader byteReader = BytesReader(bytes);
    int sampleRate = 5000; // audioSettings
    int numChannels = 1; // audioSettings
    int numSamples = bytes.length ~/ 2;

    List<Float64List> channels = <Float64List>[];
    for (int i = 0; i < numChannels; ++i) {
      channels.add(Float64List(numSamples));
    }

    // Read samples.
    SampleReader readSample = byteReader.getSampleReader(WavFormat.pcm16bit);
    for (int i = 0; i < numSamples; ++i) {
      for (int j = 0; j < numChannels; ++j) {
        channels[j][i] = readSample();
      }
    }
    return Wav(channels, sampleRate, WavFormat.pcm16bit);
  }
}