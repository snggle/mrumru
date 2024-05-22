import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';

class ReceivedPacketEvent extends APacketEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);
}
