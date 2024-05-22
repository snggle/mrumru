import 'package:mrumru/mrumru.dart';

class RemainingPacketEvent extends APacketRecognizerDataEvent {
  RemainingPacketEvent(List<double> packet) : super(packet);

  factory RemainingPacketEvent.fromJson(Map<String, dynamic> json) {
    return RemainingPacketEvent((json['packet'] as List<dynamic>).map((dynamic e) => e as double).toList());
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'ReceivedPacketEvent',
      'packet': packet,
    };
  }
}
