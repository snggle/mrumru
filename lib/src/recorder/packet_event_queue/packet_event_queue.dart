import 'package:mrumru/mrumru.dart';

class PacketEventQueue {
  List<APacketRecognizerDataEvent> eventQueue = <APacketRecognizerDataEvent>[];

  PacketEventQueue({List<APacketRecognizerDataEvent>? queue}) : eventQueue = queue ?? <APacketRecognizerDataEvent>[];

  bool isLongerThan(int waveSize) {
    int totalLength = 0;
    for (APacketRecognizerDataEvent packet in eventQueue) {
      totalLength += packet.length;
      if (totalLength >= waveSize) {
        return true;
      }
    }
    return false;
  }

  Future<List<double>> readWave(int waveSize) async {
    List<double> wave = <double>[];
    while (wave.length < waveSize) {
      APacketRecognizerDataEvent packetEvent = pop();
      wave.addAll(packetEvent.packet);
    }
    List<double> data = wave.sublist(0, waveSize);
    List<double> remainingData = wave.sublist(waveSize);
    if (remainingData.isNotEmpty) {
      push(RemainingPacketEvent(remainingData));
    }
    return data;
  }

  APacketRecognizerDataEvent pop() {
    if (eventQueue.isNotEmpty) {
      return eventQueue.removeAt(0);
    } else {
      throw Exception('Cannot read sample queue is empty');
    }
  }

  void push(APacketRecognizerDataEvent packetEvent) {
    if (packetEvent is ReceivedPacketEvent) {
      eventQueue.add(packetEvent);
    } else if (packetEvent is RemainingPacketEvent) {
      eventQueue.insert(0, packetEvent);
    }
  }
}
