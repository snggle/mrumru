import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';

class RemainingPacketEvent extends APacketEvent {
  RemainingPacketEvent(List<double> packet) : super(packet);
}
