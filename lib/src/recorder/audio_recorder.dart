import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/recorder/audio_recorder_notifier.dart';
import 'package:wav/wav.dart';

class AudioRecorder {
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;
  final IAudioSource audioSource;
  final AudioRecorderNotifier? audioRecorderNotifier;

  late final PacketRecognizer packetRecognizer;
  late final FrameModelDecoder _frameModelDecoder;

  AudioRecorder({
    required this.audioSettingsModel,
    required this.frameSettingsModel,
    required this.audioSource,
    this.audioRecorderNotifier,
  });

  Future<void> startRecording() async {
    await audioSource.init(_addEvent);
    _frameModelDecoder = FrameModelDecoder(
      framesSettingsModel: frameSettingsModel,
      onFirstFrameDecoded: (_){},
      onLastFrameDecoded: (_){
        stopRecording();
      },
      onFrameDecoded: print
    );
    packetRecognizer = PacketRecognizer(
      audioSettingsModel: audioSettingsModel,
      onDecodingCompleted: _completeDecoding,
      onFrequenciesDecoded: _readFrequencies,
    );

    unawaited(packetRecognizer.start());
  }

  void stopRecording() {
    packetRecognizer.stop();
  }

  Future<void> _completeDecoding() async {
    await audioSource.close();
    audioRecorderNotifier?.onDecodingCompleted();
  }

  void _addEvent(Uint8List packet) {
    Wav customWave = WavUtils.readPCM16Bytes(packet, audioSettingsModel);

    List<double> wave = customWave.channels.first;
    audioRecorderNotifier?.onSampleReceived(wave);

    packetRecognizer.addPacket(wave);
  }

  FrameCollectionModel get decodedContent => _frameModelDecoder.decodedContent;

  void _readFrequencies(List<DecodedFrequencyModel> frequencies) {
    List<String> binaries = frequencies.map((DecodedFrequencyModel frequency) => frequency.calcBinary(audioSettingsModel)).toList();
    _frameModelDecoder.addBinaries(binaries);
  }
}
