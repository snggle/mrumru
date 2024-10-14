import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/models/frame/frame_compression_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_encoding_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_version_number.dart';

import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of FrameProtocolID.fromValues()', () {
    test('Should [return FrameProtocolID] created from given values', () {
      // Act
      FrameProtocolID actualFrameProtocolID = FrameProtocolID.fromValues(
        frameCompressionType: FrameCompressionType.noCompression,
        frameEncodingType: FrameEncodingType.defaultMethod,
        frameProtocolType: FrameProtocolType.rawDataTransfer,
        frameVersionNumber: FrameVersionNumber.firstDefault,
      );

      // Assert
      FrameProtocolID expectedFrameProtocolID = FrameProtocolID(
        frameCompressionType: Uint8.fromInt(0),
        frameEncodingType: Uint8.fromInt(0),
        frameProtocolType: Uint8.fromInt(0),
        frameVersionNumber: Uint8.fromInt(1),
      );

      expect(actualFrameProtocolID, expectedFrameProtocolID);
    });
  });

  group('Test of FrameProtocolID.fromBytes()', () {
    test('Should [return UintReminder] containing FrameProtocolID and remaining bytes', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 1, 60, 80, 90, 100]);

      // Act
      UintReminder<FrameProtocolID> actualFrameProtocolIDReminder = FrameProtocolID.fromBytes(actualBytes);

      // Assert
      UintReminder<FrameProtocolID> expectedFrameProtocolIDReminder = UintReminder<FrameProtocolID>(
        FrameProtocolID.fromValues(
          frameCompressionType: FrameCompressionType.noCompression,
          frameEncodingType: FrameEncodingType.defaultMethod,
          frameProtocolType: FrameProtocolType.rawDataTransfer,
          frameVersionNumber: FrameVersionNumber.firstDefault,
        ),
        Uint8List.fromList(<int>[60, 80, 90, 100]),
      );

      expect(actualFrameProtocolIDReminder.value, expectedFrameProtocolIDReminder.value);
    });
  });

  group('Test of FrameProtocolID.toBytes()', () {
    test('Should [return bytes] representing FrameProtocolID', () {
      // Arrange
      FrameProtocolID actualFrameProtocolID = FrameProtocolID.fromValues(
        frameCompressionType: FrameCompressionType.noCompression,
        frameEncodingType: FrameEncodingType.defaultMethod,
        frameProtocolType: FrameProtocolType.rawDataTransfer,
        frameVersionNumber: FrameVersionNumber.firstDefault,
      );

      // Act
      Uint8List actualBytes = actualFrameProtocolID.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 1]);

      expect(actualBytes, expectedBytes);
    });
  });
}
