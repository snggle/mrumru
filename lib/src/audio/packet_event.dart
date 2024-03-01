abstract class PacketEvent {
  List<double> packet;

  PacketEvent(this.packet);
}

class ReceivedPacketEvent extends PacketEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);
}

class RemainingPacketEvent extends PacketEvent {
  RemainingPacketEvent(List<double> packet) : super(packet);
}
