import 'package:mrumru/src/audio/packet_event_queue/a_packet_event.dart';

class RemainingPacketEvent extends APacketEvent {
  RemainingPacketEvent(List<double> packet) : super(packet);
}
