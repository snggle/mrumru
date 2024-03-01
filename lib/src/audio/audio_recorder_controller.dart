import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/packet_event.dart';
import 'package:mrumru/src/audio/packet_recognizer.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/utils/wav_utils.dart';
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
    packetRecognizer = PacketRecognizer(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
      onFrameDecoded: onFrameReceived,
      onDecodingCompleted: stopRecording,
    );
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
    packetRecognizer.recordingStatus(status: true);
    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);
    recordingStreamSubscription = recordingStream.listen(_addEvent);
  }

  Future<FrameCollectionModel> stopRecording() async {
    await audioRecorder.stop();
    await recordingStreamSubscription?.cancel();
    onRecordingCompleted();
    packetRecognizer.recordingStatus(status: false);
    return packetRecognizer.decodedContent;
  }

  void _addEvent(Uint8List packet) {
    Wav customWave = WavUtils.readPCM16Bytes(packet, audioSettingsModel);
    packetRecognizer.addPacket(ReceivedPacketEvent(customWave.channels.first));
  }
}