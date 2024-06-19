import 'dart:math' as math;

import 'package:mrumru/mrumru.dart';

/// The [FskEncoder] class provides functionalities to convert binary data into
/// a list of frequencies using Frequency Shift Keying (FSK).
class FskEncoder {
  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// Creates an instance of [FskEncoder].
  FskEncoder(this._audioSettingsModel);

  /// This method encodes the binary data into frequencies, chunks them, and adds
  /// start and end frequencies based on the audio settings.
  List<List<int>> buildFrequencies(String binary) {
    List<int> baseFrequencies = _encodeBinaryToFrequencies(binary);
    List<List<int>> chunkedFrequenciesList = _chunkFrequencies(baseFrequencies)
      ..insert(0, _audioSettingsModel.startFrequencies)
      ..add(_audioSettingsModel.endFrequencies);

    return chunkedFrequenciesList;
  }

  /// This method converts each segment of binary data into a corresponding frequency
  /// based on the audio settings.
  List<int> _encodeBinaryToFrequencies(String binaryData) {
    List<int> encodedFrequencies = <int>[];
    int frequenciesCount = (binaryData.length / _audioSettingsModel.bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequency = _calculateFrequency(binaryData, i);
      encodedFrequencies.add(frequency);
    }
    return encodedFrequencies;
  }

  /// This method converts a segment of binary data into a frequency by parsing
  /// the bits and applying the frequency gap.
  int _calculateFrequency(String binaryData, int index) {
    int frequencyStartIndex = index * _audioSettingsModel.bitsPerFrequency;
    int frequencyEndIndex = frequencyStartIndex + _audioSettingsModel.bitsPerFrequency;

    String frequencyBits =
        binaryData.substring(frequencyStartIndex, math.min(frequencyEndIndex, binaryData.length)).padRight(_audioSettingsModel.bitsPerFrequency, '0');

    return _audioSettingsModel.baseFrequency + int.parse(frequencyBits, radix: 2) * _audioSettingsModel.baseFrequencyGap;
  }

  /// This method splits the base frequencies into smaller chunks and adjusts
  /// the frequencies by applying a chunk shift based on the audio settings.
  List<List<int>> _chunkFrequencies(List<int> baseFrequencies) {
    List<List<int>> chunkFrequenciesList = <List<int>>[];
    for (int i = 0; i < baseFrequencies.length; i += _audioSettingsModel.chunksCount) {
      chunkFrequenciesList.add(baseFrequencies.sublist(i, i + _audioSettingsModel.chunksCount));
    }

    List<List<int>> chunkedFrequenciesList = <List<int>>[];
    for (List<int> chunkFrequencies in chunkFrequenciesList) {
      List<int> chunkedFrequencies = <int>[];
      for (int chunkIndex = 0; chunkIndex < chunkFrequencies.length; chunkIndex++) {
        int frequency = chunkFrequencies[chunkIndex];
        int chunkedFrequency = _audioSettingsModel.parseFrequencyToChunkFrequency(frequency, chunkIndex);

        chunkedFrequencies.add(chunkedFrequency);
      }
      chunkedFrequencies = _audioSettingsModel.dynamicGap(chunkedFrequencies);
      chunkedFrequenciesList.add(chunkedFrequencies);
    }
    return chunkedFrequenciesList;
  }
}
