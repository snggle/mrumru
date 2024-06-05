import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';

class PacketReceivedEvent extends APacketEvent {
  PacketReceivedEvent(List<double> packet) : super(packet);
}
