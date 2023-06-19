import 'dart:core';
import 'dart:typed_data';

class WavDecoder {
  final int channels;
  final int sampleRate;
  final int bitDepth;

  WavDecoder(this.channels, this.sampleRate, this.bitDepth);

  List<int> readSamplesFromWav(List<int> waveBytes) {
    if (bitDepth != 8 && bitDepth != 16) {
      throw ArgumentError('Bit depth must be either 8 or 16.');
    }

    ByteData byteData = ByteData.sublistView(Uint8List.fromList(waveBytes));

    List<int> samples = <int>[];

    for (int i = 0; i < byteData.lengthInBytes; i += bitDepth ~/ 8) {
      if (bitDepth == 8) {
        // 8-bit samples are stored as unsigned ints
        samples.add(byteData.getUint8(i));
      } else if (bitDepth == 16) {
        // 16-bit samples are stored as signed ints
        samples.add(byteData.getInt16(i, Endian.little));
      }
    }
    return samples;
  }
}
