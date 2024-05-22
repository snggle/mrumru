import 'package:mrumru/mrumru.dart';

class CancelDecodingEvent extends IPacketRecognizerInputEvent {
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'CancelDecodingEvent',
    };
  }
}
