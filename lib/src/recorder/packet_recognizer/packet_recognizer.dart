import 'dart:async';

import 'package:mrumru/mrumru.dart';
import 'package:stream_isolate/stream_isolate.dart';

typedef DecodingCompletedCallback = void Function();
typedef FrequenciesDecidedCallback = void Function(List<DecodedFrequencyModel> frequencies);
typedef StartOffsetFoundCallback = void Function(int startOffset);

class PacketRecognizer {
  final AudioSettingsModel audioSettingsModel;
  final DecodingCompletedCallback? onDecodingCompleted;
  final FrequenciesDecidedCallback? onFrequenciesDecoded;
  final StartOffsetFoundCallback? onStartOffsetFound;

  BidirectionalStreamIsolate<String, String, void>? streamIsolate;

  PacketRecognizer({
    required this.audioSettingsModel,
    this.onDecodingCompleted,
    this.onFrequenciesDecoded,
    this.onStartOffsetFound,
  });

  Future<void> start() async {
    streamIsolate = await BidirectionalStreamIsolate.spawn((Stream<String> messageStream) {
      PacketRecognizerStream packetRecognizerStream = PacketRecognizerStream();
      return packetRecognizerStream.startDecoding(messageStream);
    });
    print('Stream isolate started');
    await for (String msg in streamIsolate!.stream) {
      IPacketRecognizerOutputEvent event = IPacketRecognizerOutputEvent.fromMsg(msg);
      print('Received event: ${event.runtimeType}');
      switch (event.runtimeType) {
        case DecodingCompletedEvent:
          onDecodingCompleted?.call();
          break;
        case FrequenciesDecodedEvent:
          FrequenciesDecodedEvent frequenciesDecodedEvent = event as FrequenciesDecodedEvent;
          onFrequenciesDecoded?.call(frequenciesDecodedEvent.frequencies);
          break;
        case StartOffsetFoundEvent:
          StartOffsetFoundEvent startOffsetFoundEvent = event as StartOffsetFoundEvent;
          onStartOffsetFound?.call(startOffsetFoundEvent.startOffset);
          break;
      }
    }
  }

  Future<void> addPacket(List<double> packet) async {
    print('Adding packet: ');
    streamIsolate?.send(ReceivedPacketEvent(packet).toMsg());
  }

  Future<void> stop() async {
    print('Should stop');
    streamIsolate?.send(CancelDecodingEvent().toMsg());
  }
}
