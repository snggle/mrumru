import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:wav/bytes_reader.dart';
import 'package:wav/wav.dart';

class WavUtils {
  static Wav readPCM16Bytes(Uint8List bytes, AudioSettingsModel audioSettingsModel) {
    BytesReader byteReader = BytesReader(bytes);
    int numSamples = bytes.length ~/ 2;
    List<Float64List> channels = <Float64List>[];
    for (int i = 0; i < audioSettingsModel.channels; ++i) {
      channels.add(Float64List(numSamples));
    }
    SampleReader sampleReader = byteReader.getSampleReader(WavFormat.pcm16bit);
    for (int i = 0; i < numSamples; ++i) {
      for (int j = 0; j < audioSettingsModel.channels; ++j) {
        channels[j][i] = sampleReader();
      }
    }
    return Wav(channels, audioSettingsModel.sampleRate, WavFormat.pcm16bit);
  }
}
