import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';

class PacketRemainingEvent extends APacketEvent {
  PacketRemainingEvent(List<double> packet) : super(packet);
}
