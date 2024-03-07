abstract class PacketEvent {
  final List<double> packet;
  final int length;

  PacketEvent(this.packet) : length = packet.length;
}

class ReceivedPacketEvent extends PacketEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);
}

class RemainingPacketEvent extends PacketEvent {
  RemainingPacketEvent(List<double> packet) : super(packet);
}
