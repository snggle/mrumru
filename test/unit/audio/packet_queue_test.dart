import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/audio/packet_event_queue/a_packet_event.dart';
import 'package:mrumru/src/audio/packet_event_queue/packet_event_queue.dart';
import 'package:mrumru/src/audio/packet_event_queue/received_packet_event.dart';
import 'package:mrumru/src/audio/packet_event_queue/remaining_packet_event.dart';

void main() {
  group('Test of PacketQueue.push() method process', () {
    PacketEventQueue actualPacketEventQueue = PacketEventQueue();
    ReceivedPacketEvent actualFirstPacketEvent = ReceivedPacketEvent(List<double>.filled(8, 0));
    ReceivedPacketEvent actualSecondPacketEvent = ReceivedPacketEvent(List<double>.filled(8, 1));

    test('Should [add ReceivedPacketEvent] to queue if [queue EMPTY]', () {
      // Act
      actualPacketEventQueue.push(actualFirstPacketEvent);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualFirstPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });

    test('Should [add ReceivedPacketEvent] to queue if [queue NOT EMPTY]', () {
      // Act
      actualPacketEventQueue.push(actualSecondPacketEvent);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualFirstPacketEvent, actualSecondPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });

    test('Should [add RemainingPacketEvent] to queue as first element', () {
      // Arrange
      RemainingPacketEvent actualRemainingPacket = RemainingPacketEvent(List<double>.filled(8, 2));

      // Act
      actualPacketEventQueue.push(actualRemainingPacket);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualRemainingPacket, actualFirstPacketEvent, actualSecondPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });
  });

  group('Test of PacketQueue.isLongerThan() method', () {
    List<double> actualSamples = List<double>.filled(8, 0);
    ReceivedPacketEvent actualPacketEvent = ReceivedPacketEvent(actualSamples);
    PacketEventQueue actualPacketEventQueue = PacketEventQueue(queue: <APacketEvent>[actualPacketEvent]);

    test('Should [return TRUE] if [queue LONGER] than given length', () {
      // Act
      bool actualResultBool = actualPacketEventQueue.isLongerThan(8);

      // Assert
      expect(actualResultBool, true);
    });

    test('Should [return FALSE] if [queue SHORTER] than given length', () {
      // Act
      bool actualResultBool = actualPacketEventQueue.isLongerThan(10);

      // Assert
      expect(actualResultBool, false);
    });

    test('Should [return FALSE] if [queue EMPTY]', () {
      // Arrange
      PacketEventQueue actualPacketEventQueue = PacketEventQueue();

      // Act
      bool actualResultBool = actualPacketEventQueue.isLongerThan(8);

      // Assert
      expect(actualResultBool, false);
    });
  });

  group('Test of PacketQueue.readWave() method', () {
    ReceivedPacketEvent actualPacket = ReceivedPacketEvent(List<double>.filled(8, 0));

    test('Should [return wave] from queue with given size', () async {
      // Arrange
      PacketEventQueue actualPacketEventQueue = PacketEventQueue(queue: <APacketEvent>[actualPacket]);

      // Act
      List<double> actualReadWave = await actualPacketEventQueue.readWave(8);

      // Assert
      List<double> actualExpectedSamplesInOrder = <double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

      expect(actualReadWave, actualExpectedSamplesInOrder);
    });

    test('Should [throw EXCEPTION] if [queue SHORTER] than given length', () async {
      // Arrange
      PacketEventQueue actualPacketEventQueue = PacketEventQueue(queue: <APacketEvent>[actualPacket]);

      // Assert
      expect(() => actualPacketEventQueue.readWave(10), throwsA(isA<Exception>()));
    });

    test('Should [throw EXCEPTION] if [queue EMPTY]', () async {
      // Arrange
      PacketEventQueue actualPacketEventQueue = PacketEventQueue();

      // Assert
      expect(() => actualPacketEventQueue.readWave(8), throwsA(isA<Exception>()));
    });
  });

  group('Test of PacketQueue.pop() method process', () {
    ReceivedPacketEvent actualFirstPacket = ReceivedPacketEvent(List<double>.filled(8, 0));
    ReceivedPacketEvent actualSecondPacket = ReceivedPacketEvent(List<double>.filled(8, 1));
    PacketEventQueue actualPacketEventQueue = PacketEventQueue(queue: <APacketEvent>[actualFirstPacket, actualSecondPacket]);

    test('Should [remove and return] first event in the queue and [leave queue with one element]', () {
      // Act
      APacketEvent actualPoppedPacketEvent = actualPacketEventQueue.pop();

      // Assert
      ReceivedPacketEvent expectedPoppedEvent = ReceivedPacketEvent(List<double>.filled(8, 0));

      expect(actualPoppedPacketEvent.packet, expectedPoppedEvent.packet);
    });

    test('Should [remove and return] first event in the queue and [leave queue empty]', () {
      // Act
      APacketEvent actualPoppedPacketEvent = actualPacketEventQueue.pop();

      // Assert
      ReceivedPacketEvent expectedPoppedEvent = ReceivedPacketEvent(List<double>.filled(8, 1));

      expect(actualPoppedPacketEvent.packet, expectedPoppedEvent.packet);
    });

    test('Should [throw EXCEPTION] if [queue EMPTY]', () {
      // Assert
      expect(() => actualPacketEventQueue.pop(), throwsA(isA<Exception>()));
    });
  });
}
