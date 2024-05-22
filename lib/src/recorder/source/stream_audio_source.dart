import 'dart:async';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/recorder/source/i_audio_source.dart';
import 'package:record/record.dart' as record;

class StreamAudioSource implements IAudioSource {
  final record.AudioRecorder audioRecorder;
  final AudioSettingsModel audioSettingsModel;

  late StreamSubscription<Uint8List> recordingStreamSubscription;

  StreamAudioSource({
    required this.audioSettingsModel,
  }) : audioRecorder = record.AudioRecorder();

  @override
  Future<void> init(PacketReceivedCallback packetReceivedCallback) async {
    record.RecordConfig recordConfig = record.RecordConfig(
      encoder: record.AudioEncoder.pcm16bits,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);

    recordingStreamSubscription = recordingStream.listen(packetReceivedCallback);
  }

  @override
  Future<void> close() async {
    await recordingStreamSubscription.cancel();
    if (await audioRecorder.isRecording()) {
      await audioRecorder.stop();
    }
  }
}
