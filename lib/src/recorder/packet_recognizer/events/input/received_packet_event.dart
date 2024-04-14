import 'package:mrumru/mrumru.dart';

class ReceivedPacketEvent extends APacketRecognizerDataEvent {
  ReceivedPacketEvent(List<double> packet) : super(packet);

  factory ReceivedPacketEvent.fromJson(Map<String, dynamic> json) {
    return ReceivedPacketEvent((json['packet'] as List<dynamic>).map((dynamic e) => e as double).toList());
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'ReceivedPacketEvent',
      'packet': packet,
    };
  }
}
