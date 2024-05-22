import 'package:mrumru/mrumru.dart';

abstract class APacketRecognizerDataEvent extends IPacketRecognizerInputEvent {
  final List<double> packet;
  final int length;

  APacketRecognizerDataEvent(this.packet) : length = packet.length;
}
