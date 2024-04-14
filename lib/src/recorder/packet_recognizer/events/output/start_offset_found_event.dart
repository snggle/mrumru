import 'package:mrumru/mrumru.dart';

class StartOffsetFoundEvent extends IPacketRecognizerOutputEvent {
  final int startOffset;

  StartOffsetFoundEvent(this.startOffset);

  StartOffsetFoundEvent.fromJson(Map<String, dynamic> json)
      : startOffset = json['startOffset'] as int;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'StartOffsetFoundEvent',
      'startOffset': startOffset,
    };
  }
}