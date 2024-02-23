import 'dart:async';
import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/utils/math_utils.dart';
import 'package:mrumru/src/utils/wav_utils.dart';
import 'package:record/record.dart';
import 'package:wav/wav.dart';

class AudioRecorderController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioSettingsModel audioSettingsModel;
  late final PacketRecognizer packetRecognizer;
  StreamSubscription<Uint8List>? recordingStreamSubscription;

  AudioRecorderController({required this.audioSettingsModel});

  Future<void> startRecording() async {
    packetRecognizer = PacketRecognizer(audioSettingsModel: audioSettingsModel);
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);
    recordingStreamSubscription = recordingStream.listen(_handlePacketReceived);
  }

  Future<List<double>> stopRecording() async {
    await audioRecorder.stop();
    await recordingStreamSubscription?.cancel();
    print('complete frequencies: ${packetRecognizer.decodedFrequencies.map((DecodedFrequency e) => e.chunkFrequency).join(' ')}');
    print('complete binary: ${packetRecognizer.decodedFrequencies.map((DecodedFrequency e) => e.calcBinary(audioSettingsModel)).join('')}');

    return <double>[];
  }

  void _handlePacketReceived(Uint8List packet) {
    Wav customWave = WavUtils.readPCM16Bytes(packet, audioSettingsModel);
    packetRecognizer.add(customWave.channels.first);
  }
}

class IndexCorrelation extends Equatable {
  final int index;
  final double correlation;

  const IndexCorrelation({required this.index, required this.correlation});

  @override
  List<Object?> get props => <Object?>[index, correlation];
}

class PacketRecognizer {
  final AudioSettingsModel audioSettingsModel;
  final double amplitude;
  final int sampleSize;
  final int sampleRate;
  final int chunksCount;
  final List<int> startFrequencies;

  late final int maxStartOffset = (5 * sampleSize).toInt();

  final ValueNotifier<List<double>> originalWave = ValueNotifier<List<double>>(<double>[]);

  int? startOffset;
  int? endOffset;
  int cursor = 0;
  bool processing = false;

  List<DecodedFrequency> decodedFrequencies = <DecodedFrequency>[];

  PacketRecognizer({
    required this.audioSettingsModel,
  })  : sampleSize = audioSettingsModel.sampleSize,
        sampleRate = audioSettingsModel.sampleRate,
        chunksCount = audioSettingsModel.chunksCount,
        amplitude = audioSettingsModel.amplitude,
        startFrequencies = audioSettingsModel.startFrequencies;

  void add(List<double> packet) {
    print('PacketRecognizer: Add packet (Size: ${packet.length})');
    originalWave.value = <double>[...originalWave.value, ...packet];
    if (startOffset == null && originalWave.value.length >= maxStartOffset) {
      _findStartOffset(List<double>.from(originalWave.value));
      _startDecoding();
    }
  }

  void _startDecoding() {
    assert(startOffset != null, 'Start offset must be set before decoding');
    cursor = startOffset!;
    print('PacketRecognizer: Set cursor to $cursor');
    _processData();
    originalWave.addListener(() {
      if (!processing) {
        _processData();
      }
    });
  }

  void _processData() {
    print('PacketRecognizer: Process data (Cursor: $cursor)');
    processing = true;
    List<double> waveToProcess = originalWave.value.sublist(cursor);
    int currentSampleCount = waveToProcess.length ~/ sampleSize;
    for (int i = 0; i < currentSampleCount; i++) {
      List<double> sample = waveToProcess.sublist(i * sampleSize, (i + 1) * sampleSize);
      decodedFrequencies.addAll(_translateSample(sample));
      cursor += sampleSize;
      print('PacketRecognizer: Set cursor to $cursor');
    }
    tryReadBinary();
    processing = false;
  }

  void tryReadBinary() {
    String currentBinary = decodedFrequencies.map((DecodedFrequency e) => e.calcBinary(audioSettingsModel)).join('');
    for(int i = 0; i < currentBinary.length; i += 56) {
      String frameBits = currentBinary.substring(i, math.min(i + 56, currentBinary.length));
      if(frameBits.length < 56) {
        break;
      }
      FrameModel frame = FrameModel.fromBinaryString(frameBits);
      print('Read frame: $frame');
      endOffset = (frame.framesCount * 56 / 2 * audioSettingsModel.sampleSize * sampleRate).toInt();
      print('endOffset: $endOffset');
    }
  }

  List<DecodedFrequency> _translateSample(List<double> sample) {
    List<DecodedFrequency> frequencies = <DecodedFrequency>[];
    for (int chunkIndex = 0; chunkIndex < chunksCount; chunkIndex++) {
      int highestFrequency = _findHighestFrequency(sample, chunkIndex);
      DecodedFrequency decodedFrequency = DecodedFrequency(chunkFrequency: highestFrequency, chunkIndex: chunkIndex);
      frequencies.add(decodedFrequency);
    }
    return frequencies;
  }

  int _findHighestFrequency(List<double> chunkFrequencySample, int chunkIndex) {
    List<FrequencyCorrelationModel> frequencyCorrelations = _calculateFrequencyCorrelations(chunkFrequencySample, chunkIndex);
    int highestFrequency =
        frequencyCorrelations.reduce((FrequencyCorrelationModel a, FrequencyCorrelationModel b) => a.correlation > b.correlation ? a : b).frequency;
    return highestFrequency;
  }

  List<FrequencyCorrelationModel> _calculateFrequencyCorrelations(List<double> chunkFrequencySample, int chunkIndex) {
    List<FrequencyCorrelationModel> frequencyCorrelations = <FrequencyCorrelationModel>[];

    for (int possibleFrequency in audioSettingsModel.possibleFrequencies) {
      int frequencyRange = audioSettingsModel.frequencyRange;
      int chunkFrequency = possibleFrequency + chunkIndex * frequencyRange;
      double correlation = _calculateAmplitude(chunkFrequencySample, chunkFrequency);
      frequencyCorrelations.add(FrequencyCorrelationModel(correlation: correlation, frequency: chunkFrequency));
    }

    return frequencyCorrelations;
  }

  double _calculateAmplitude(List<double> samples, int frequency) {
    int sampleCount = samples.length;
    double angleStep = (2 * math.pi * frequency) / sampleRate;
    double sumCos = 0;
    double sumSin = 0;

    for (int i = 0; i < sampleCount; i++) {
      double sampleValue = samples[i] / amplitude;
      double sincValue = MathUtils.sinc(i.toDouble() / sampleCount - 0.5);

      sumCos += sampleValue * math.cos(i * angleStep) * sincValue;
      sumSin += sampleValue * math.sin(i * angleStep) * sincValue;
    }

    double calculatedAmplitude = 2 * math.sqrt(sumCos * sumCos + sumSin * sumSin) / sampleCount;
    return calculatedAmplitude;
  }

  void _findStartOffset(List<double> wave) {
    print('PacketRecognizer: Find start offset');
    List<List<double>> templateSineWaves = _getTemplateSineWaves(startFrequencies);

    List<IndexCorrelation> correlations = <IndexCorrelation>[];

    for (int i = 0; i < math.min(wave.length - sampleSize, (maxStartOffset * sampleRate).toInt()); i++) {
      int windowStart = i;
      int windowEnd = i + sampleSize;
      List<double> window = wave.sublist(windowStart, windowEnd);
      double windowCorrelation = _calcCorrelation(window, templateSineWaves);
      correlations.add(IndexCorrelation(correlation: windowCorrelation, index: windowStart));
    }

    IndexCorrelation maxCorrelation = correlations.reduce((IndexCorrelation a, IndexCorrelation b) => a.correlation > b.correlation ? a : b);
    startOffset = maxCorrelation.index + sampleSize;
    print('PacketRecognizer: Start offset found: $startOffset');
  }

  List<List<double>> _getTemplateSineWaves(List<int> templateFrequencies) {
    List<List<double>> templateSineWaves = <List<double>>[];

    for (int freq in templateFrequencies) {
      List<double> t = List<double>.generate(sampleSize, (int i) => i / sampleRate);
      List<double> sineWave = t.map((double ti) => math.sin(2 * math.pi * freq * ti)).toList();

      templateSineWaves.add(sineWave);
    }

    return templateSineWaves;
  }

  double _calcCorrelation(List<double> window, List<List<double>> templateSineWaves) {
    double windowCorrelation = 0.0;

    for (List<double> template in templateSineWaves) {
      double sum = 0.0;
      for (int j = 0; j < sampleSize; j++) {
        sum += window[j] * template[j];
      }
      windowCorrelation += sum.abs();
    }

    return windowCorrelation;
  }
}

class DecodedFrequency {
  final int chunkFrequency;
  final int chunkIndex;

  const DecodedFrequency({
    required this.chunkFrequency,
    required this.chunkIndex,
  });

  String calcBinary(AudioSettingsModel audioSettingsModel) {
    int frequency = chunkFrequency - chunkIndex * audioSettingsModel.frequencyRange;
    String chunkBits = _convertFrequencyToBits(frequency, audioSettingsModel);
    return chunkBits;
  }

  String _convertFrequencyToBits(int correctedFrequency, AudioSettingsModel audioSettingsModel) {
    int bits = ((correctedFrequency - audioSettingsModel.baseFrequency) / audioSettingsModel.frequencyGap).round();
    return bits.toRadixString(2).padLeft(audioSettingsModel.bitsPerFrequency, '0');
  }
}
