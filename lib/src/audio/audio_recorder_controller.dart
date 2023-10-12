import 'dart:async';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:record/record.dart';

class AudioRecorderController {
  StreamSubscription<Uint8List>? recordingStreamSubscription;
  final AudioRecorder audioRecorder = AudioRecorder();
  final List<Uint8List> receivedPackets = <Uint8List>[];

  Future<void> startRecording(AudioSettingsModel audioSettingsModel) async {
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.wav,
      bitRate: audioSettingsModel.bitDepth * audioSettingsModel.sampleRate * audioSettingsModel.channels,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );

    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);
    recordingStreamSubscription = recordingStream.listen(_handlePacketReceived);
  }

  Future<Uint8List> stopRecording() async {
    await audioRecorder.stop();
    await recordingStreamSubscription?.cancel();
    List<int> waveBytes = receivedPackets.reduce((Uint8List value, Uint8List element) => Uint8List.fromList(value + element));

    return Uint8List.fromList(waveBytes);
  }

  void _handlePacketReceived(Uint8List packet) {
    receivedPackets.add(packet);
  }
}
