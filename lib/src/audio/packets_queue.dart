import 'package:mrumru/src/audio/packet_event.dart';

// Priority queue
class PacketsQueue {
  final List<PacketEvent> _queue = <PacketEvent>[];

  Future<List<double>> readWave(int size) async {
    List<double> wave = <double>[];
    while (wave.length < size) {
      PacketEvent event = pop();
      wave.addAll(event.packet);
    }
    List<double> data = wave.sublist(0, size);
    List<double> remainingData = wave.sublist(size);
    if (remainingData.isNotEmpty) {
      push(RemainingPacketEvent(remainingData));
    }
    return data;
  }

  PacketEvent pop() {
    return _queue.removeAt(0);
  }

  void push(PacketEvent packet) {
    if (packet is ReceivedPacketEvent) {
      _queue.add(packet);
    } else if (packet is RemainingPacketEvent) {
      _queue.insert(0, packet);
    }
  }

  bool get isNotEmpty => _queue.isNotEmpty;

  int get eventCount => _queue.length;

  bool isLongerThan(int length) {
    int totalLength = 0;
    for (PacketEvent packet in _queue) {
      totalLength += packet.packet.length;
      if (totalLength >= length) {
        return true;
      }
    }
    return false;
  }
}
