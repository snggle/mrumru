import 'package:mrumru/mrumru.dart';

class DecodingCompletedEvent extends IPacketRecognizerOutputEvent {
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'DecodingCompletedEvent',
    };
  }
}