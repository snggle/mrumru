abstract class APacketEvent {
  final List<double> packet;
  final int length;

  APacketEvent(this.packet) : length = packet.length;
}
