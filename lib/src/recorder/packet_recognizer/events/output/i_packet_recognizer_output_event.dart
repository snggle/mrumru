import 'dart:convert';

import 'package:mrumru/mrumru.dart';

abstract class IPacketRecognizerOutputEvent {
  Map<String, dynamic> toJson();

  String toMsg() {
    return jsonEncode(toJson());
  }

  static IPacketRecognizerOutputEvent fromMsg(String msg) {
    Map<String, dynamic> json = jsonDecode(msg) as Map<String, dynamic>;

    switch (json['type'] as String) {
      case 'StartOffsetFoundEvent':
        return StartOffsetFoundEvent.fromJson(json);
      case 'DecodingCompletedEvent':
        return DecodingCompletedEvent();
      case 'FrequenciesDecodedEvent':
        return FrequenciesDecodedEvent.fromJson(json);
      default:
        throw ArgumentError('Unknown type: ${json['type']}');
    }
  }
}