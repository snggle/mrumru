import 'package:mrumru/mrumru.dart';

class FrequenciesDecodedEvent extends IPacketRecognizerOutputEvent {
  final List<DecodedFrequencyModel> frequencies;

  FrequenciesDecodedEvent(this.frequencies);

  FrequenciesDecodedEvent.fromJson(Map<String, dynamic> json)
      : frequencies = (json['frequencies'] as List<dynamic>).map((dynamic f) => DecodedFrequencyModel.fromJson(f as Map<String, dynamic>)).toList();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'FrequenciesDecodedEvent',
      'frequencies': frequencies.map((DecodedFrequencyModel f) => f.toJson()).toList(),
    };
  }
}