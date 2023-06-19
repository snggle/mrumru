import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

// ignore_for_file: constant_identifier_names
class WavEncoder {
  static const int RIFF_TAG = 0x52494646;
  static const int WAVE_TAG = 0x57415645;
  static const int FORMAT_TAG = 0x666d7420;
  static const int DATA_TAG = 0x64617461;

  final int channels;
  final int sampleRate;
  final int bitDepth;

  WavEncoder(this.channels, this.sampleRate, this.bitDepth);

  Uint8List buildWavFromSamples(List<int> samples) {
    int dataSize = samples.length * (bitDepth ~/ 8);

    Uint8List headerBytes = _buildWavHeader(samples, dataSize);
    Uint8List bodyBytes = _buildWavBody(samples, dataSize);

    Uint8List waveBytes = Uint8List(headerBytes.length + bodyBytes.length)
      ..setAll(0, headerBytes)
      ..setAll(headerBytes.length, bodyBytes);
    return waveBytes;
  }

  Uint8List _buildWavHeader(List<int> samples, int dataSize) {
    int byteRate = sampleRate * channels * (bitDepth ~/ 8);
    int blockAlign = channels * (bitDepth ~/ 8);
    int fileSize = 44 + dataSize;

    // Wave header
    Uint8List headerBytes = Uint8List(44);
    ByteData.view(headerBytes.buffer)
      // RIFF chunk
      ..setUint32(0, RIFF_TAG, Endian.big)
      ..setUint32(4, fileSize - 8, Endian.little)
      ..setUint32(8, WAVE_TAG, Endian.big)

      // Format sub-chunk
      ..setUint32(12, FORMAT_TAG, Endian.big)
      ..setUint32(16, 16, Endian.little)
      ..setUint16(20, 1, Endian.little)
      ..setUint16(22, channels, Endian.little)
      ..setUint32(24, sampleRate, Endian.little)
      ..setUint32(28, byteRate, Endian.little)
      ..setUint16(32, blockAlign, Endian.little)
      ..setUint16(34, bitDepth, Endian.little)

      // Write the data subchunk
      ..setUint32(36, DATA_TAG, Endian.big)
      ..setUint32(40, dataSize, Endian.little);

    return headerBytes;
  }

  Uint8List _buildWavBody(List<int> samples, int dataSize) {
    Uint8List dataBytes = Uint8List(dataSize);
    ByteData dataView = ByteData.view(dataBytes.buffer);

    for (int i = 0; i < samples.length; i++) {
      if (bitDepth == 8) {
        // 8-bit samples are stored as unsigned ints
        dataView.setUint8(i, samples[i]);
      } else if (bitDepth == 16) {
        // 16-bit samples are stored as signed ints
        dataView.setInt16(i * 2, samples[i], Endian.little);
      }
    }
    return dataBytes;
  }
}
