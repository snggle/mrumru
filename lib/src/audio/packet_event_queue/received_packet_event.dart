import 'package:mrumru/src/audio/packet_event_queue/a_packet_event.dart';

class ReceivedPacketEvent extends APacketEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);
}
