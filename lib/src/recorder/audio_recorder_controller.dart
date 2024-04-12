import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:record/record.dart';
import 'package:wav/wav.dart';

class AudioRecorderController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final ValueChanged<FrameModel>? onFrameReceived;
  final VoidCallback onRecordingCompleted;
  final AudioSettingsModel audioSettingsModel;
  final FrameSettingsModel frameSettingsModel;
  late final PacketRecognizer packetRecognizer;
  StreamSubscription<Uint8List>? recordingStreamSubscription;

  AudioRecorderController({
    required this.audioSettingsModel,
    required this.onRecordingCompleted,
    required this.onFrameReceived,
    required this.frameSettingsModel,
  });

  Future<void> startRecording() async {
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);

    packetRecognizer = PacketRecognizer(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
      onFrameDecoded: onFrameReceived,
      onDecodingCompleted: _completeDecoding,
    );

    unawaited(packetRecognizer.startDecoding());

    recordingStreamSubscription = recordingStream.listen(_addEvent);
  }

  void stopRecording() {
    packetRecognizer.stopRecording();
  }

  Future<void> _completeDecoding() async {
    if (await audioRecorder.isRecording()) {
      await audioRecorder.stop();
      await recordingStreamSubscription?.cancel();
      onRecordingCompleted();
    }
  }

  void _addEvent(Uint8List packet) {
    Wav customWave = WavUtils.readPCM16Bytes(packet, audioSettingsModel);
    packetRecognizer.addPacket(ReceivedPacketEvent(customWave.channels.first));
  }
}
