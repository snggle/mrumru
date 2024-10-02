import 'dart:math' as math;
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';

/// The [SampleGenerator] class is responsible for generating samples from binary data.
/// It takes the binary data and processes it into samples.
class SampleGenerator {
  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// Creates an instance of [SampleGenerator].
  SampleGenerator(this._audioSettingsModel);

  /// This method builds samples from the binary data using FSK.
  List<SampleModel> buildSamplesFromBinary(String binary) {
    List<int> baseFrequencies = _encodeBinaryToBaseFrequencies(binary);

    SampleModel startSampleModel = SampleModel(chunkedFrequencies: _audioSettingsModel.startFrequencies, audioSettingsModel: _audioSettingsModel);
    SampleModel endSampleModel = SampleModel(chunkedFrequencies: _audioSettingsModel.endFrequencies, audioSettingsModel: _audioSettingsModel);

    List<SampleModel> samples = _buildSamplesFromBaseFrequencies(baseFrequencies)
      ..insert(0, startSampleModel)
      ..add(endSampleModel);
    return samples;
  }

  /// This method encodes the binary data into base frequencies.
  List<int> _encodeBinaryToBaseFrequencies(String binaryData) {
    List<int> encodedFrequencies = <int>[];
    int frequenciesCount = (binaryData.length / _audioSettingsModel.bitsPerFrequency).ceil();

    for (int i = 0; i < frequenciesCount; i++) {
      int frequency = _calculateBaseFrequency(binaryData, i);
      encodedFrequencies.add(frequency);
    }
    return encodedFrequencies;
  }

  /// This method calculates base frequency from the binary data.
  int _calculateBaseFrequency(String binaryData, int index) {
    int frequencyStartIndex = index * _audioSettingsModel.bitsPerFrequency;
    int frequencyEndIndex = frequencyStartIndex + _audioSettingsModel.bitsPerFrequency;

    String frequencyBits = binaryData.substring(frequencyStartIndex, math.min(frequencyEndIndex, binaryData.length));
    frequencyBits = frequencyBits.padRight(_audioSettingsModel.bitsPerFrequency, '0');

    return _audioSettingsModel.firstFrequency + int.parse(frequencyBits, radix: 2) * _audioSettingsModel.baseFrequencyGap;
  }

  /// This method builds samples from the base frequencies list.
  List<SampleModel> _buildSamplesFromBaseFrequencies(List<int> allBaseFrequencies) {
    List<SampleModel> samples = <SampleModel>[];

    for (int i = 0; i < allBaseFrequencies.length; i += _audioSettingsModel.chunksCount) {
      int endIndex = math.min(i + _audioSettingsModel.chunksCount, allBaseFrequencies.length);
      List<int> sampleBaseFrequencies = allBaseFrequencies.sublist(i, endIndex);
      List<int> sampleChunkedFrequencies = _allocateFrequenciesToChunks(sampleBaseFrequencies);
      sampleChunkedFrequencies = _audioSettingsModel.assignDynamicGap(sampleChunkedFrequencies);

      samples.add(SampleModel(chunkedFrequencies: sampleChunkedFrequencies, audioSettingsModel: _audioSettingsModel));
    }
    return samples;
  }

  /// This method allocates frequencies to chunks based on the base frequencies.
  List<int> _allocateFrequenciesToChunks(List<int> sampleBaseFrequencies) {
    List<int> sampleChunkedFrequencies = <int>[];
    for (int chunkIndex = 0; chunkIndex < sampleBaseFrequencies.length; chunkIndex++) {
      int baseFrequency = sampleBaseFrequencies[chunkIndex];
      int chunkedFrequency = _audioSettingsModel.parseBaseFrequencyToChunkFrequency(baseFrequency, chunkIndex);

      sampleChunkedFrequencies.add(chunkedFrequency);
    }
    return sampleChunkedFrequencies;
  }
}
