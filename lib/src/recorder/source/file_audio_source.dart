import 'package:mrumru/src/recorder/source/i_audio_source.dart';

class FileAudioSource implements IAudioSource {
  @override
  Future<void> init(PacketReceivedCallback packetReceivedCallback) async {}

  @override
  Future<void> close() async {}
}
