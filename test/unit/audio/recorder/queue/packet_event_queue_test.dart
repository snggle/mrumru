import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_remaining_event.dart';
import 'package:mrumru/src/audio/recorder/queue/packet_event_queue.dart';

void main() {
  group('Test of PacketEventQueue.push() method process', () {
    PacketEventQueue actualPacketEventQueue = PacketEventQueue();
    PacketReceivedEvent actualFirstPacketEvent = PacketReceivedEvent(List<double>.filled(8, 0));
    PacketReceivedEvent actualSecondPacketEvent = PacketReceivedEvent(List<double>.filled(8, 1));

    test('Should [add PacketReceivedEvent] to queue if [queue EMPTY]', () {
      // Act
      actualPacketEventQueue.push(actualFirstPacketEvent);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualFirstPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });

    test('Should [add PacketReceivedEvent] to queue if [queue NOT EMPTY]', () {
      // Act
      actualPacketEventQueue.push(actualSecondPacketEvent);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualFirstPacketEvent, actualSecondPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });

    test('Should [add PacketRemainingEvent] to queue as first element', () {
      // Arrange
      PacketRemainingEvent actualRemainingPacket = PacketRemainingEvent(List<double>.filled(8, 2));

      // Act
      actualPacketEventQueue.push(actualRemainingPacket);

      // Assert
      List<APacketEvent> expectedPacketEventQueue = <APacketEvent>[actualRemainingPacket, actualFirstPacketEvent, actualSecondPacketEvent];

      expect(actualPacketEventQueue.eventQueue, expectedPacketEventQueue);
    });
  });

  group('Test of PacketEventQueue.isLongerThan() method', () {
    List<double> actualSamples = List<double>.filled(8, 0);
    PacketReceivedEvent actualPacketEvent = PacketReceivedEvent(actualSamples);
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

  group('Test of PacketEventQueue.readWave() method', () {
    PacketReceivedEvent actualPacket = PacketReceivedEvent(List<double>.filled(8, 0));

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

  group('Test of PacketEventQueue.pop() method process', () {
    PacketReceivedEvent actualFirstPacket = PacketReceivedEvent(List<double>.filled(8, 0));
    PacketReceivedEvent actualSecondPacket = PacketReceivedEvent(List<double>.filled(8, 1));
    PacketEventQueue actualPacketEventQueue = PacketEventQueue(queue: <APacketEvent>[actualFirstPacket, actualSecondPacket]);

    test('Should [remove and return] first event in the queue and [leave queue with one element]', () {
      // Act
      APacketEvent actualPoppedPacketEvent = actualPacketEventQueue.pop();

      // Assert
      PacketReceivedEvent expectedPoppedEvent = PacketReceivedEvent(List<double>.filled(8, 0));

      expect(actualPoppedPacketEvent.packet, expectedPoppedEvent.packet);
    });

    test('Should [remove and return] first event in the queue and [leave queue empty]', () {
      // Act
      APacketEvent actualPoppedPacketEvent = actualPacketEventQueue.pop();

      // Assert
      PacketReceivedEvent expectedPoppedEvent = PacketReceivedEvent(List<double>.filled(8, 1));

      expect(actualPoppedPacketEvent.packet, expectedPoppedEvent.packet);
    });

    test('Should [throw EXCEPTION] if [queue EMPTY]', () {
      // Assert
      expect(() => actualPacketEventQueue.pop(), throwsA(isA<Exception>()));
    });
  });
}
