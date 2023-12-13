import 'dart:async';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/models/wav_utils.dart';
import 'package:record/record.dart';
import 'package:wav/wav.dart';

class AudioRecorderController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final List<double> receivedPackets = <double>[];

  StreamSubscription<Uint8List>? recordingStreamSubscription;

  Future<void> startRecording(AudioSettingsModel audioSettingsModel) async {
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      bitRate: audioSettingsModel.bitDepth * audioSettingsModel.sampleRate * audioSettingsModel.channels,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );

    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);
    recordingStreamSubscription = recordingStream.listen(_handlePacketReceived);
  }

  Future<List<double>> stopRecording() async {
    await audioRecorder.stop();
    await recordingStreamSubscription?.cancel();
    return receivedPackets;
  }

  Future<void> _handlePacketReceived(Uint8List packet) async {
    Wav customWave = CustomWav.readWithoutHeaders(packet);
    print(customWave.channels.first);
    receivedPackets.addAll(customWave.channels.first);
  }
}
