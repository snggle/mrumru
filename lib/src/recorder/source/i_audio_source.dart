import 'dart:typed_data';

typedef PacketReceivedCallback = void Function(Uint8List packet);

abstract class IAudioSource {
  Future<void> init(PacketReceivedCallback packetReceivedCallback);

  Future<void> close();
}