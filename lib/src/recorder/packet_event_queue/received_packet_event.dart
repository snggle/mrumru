import 'package:mrumru/mrumru.dart';

class ReceivedPacketEvent extends APacketEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);
}
