import 'dart:convert';

import 'package:mrumru/mrumru.dart';

abstract class IPacketRecognizerInputEvent {
  Map<String, dynamic> toJson();

  String toMsg() {
    return jsonEncode(toJson());
  }

  static IPacketRecognizerInputEvent fromMsg(String msg) {
    Map<String, dynamic> json = jsonDecode(msg) as Map<String, dynamic>;

    switch (json['type'] as String) {
      case 'ReceivedPacketEvent':
        return ReceivedPacketEvent.fromJson(json);
      case 'RemainingPacketEvent':
        return RemainingPacketEvent.fromJson(json);
      case 'CancelDecodingEvent':
        return CancelDecodingEvent();
      default:
        throw ArgumentError('Unknown type: ${json['type']}');
    }
  }
}
