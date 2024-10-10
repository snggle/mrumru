import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';

import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of Uint32FrameProtocolID.toBytes()', () {
    test('Should return correct bytes representation', () {
      // Arrange
      Uint32FrameProtocolID actualFrameProtocolID = Uint32FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );

      // Act
      Uint8List actualBytes = actualFrameProtocolID.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        actualFrameProtocolID.frameCompressionType.toInt(),
        actualFrameProtocolID.frameEncodingType.toInt(),
        actualFrameProtocolID.frameProtocolType.toInt(),
        actualFrameProtocolID.frameVersionNumber.toInt(),
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of Uint32FrameProtocolID.fromValues()', () {
    test('Should construct Uint32FrameProtocolID correctly from given values', () {
      // Arrange
      FrameCompressionType actualFrameCompressionType = FrameCompressionType.noCompression;
      FrameEncodingType actualFrameEncodingType = FrameEncodingType.defaultMethod;
      FrameProtocolType actualFrameProtocolType = FrameProtocolType.rawDataTransfer;
      FrameVersionNumber actualFrameVersionNumber = FrameVersionNumber.firstDefault;

      // Act
      Uint32FrameProtocolID actualFrameProtocolID = Uint32FrameProtocolID.fromValues(
        frameCompressionType: actualFrameCompressionType,
        frameEncodingType: actualFrameEncodingType,
        frameProtocolType: actualFrameProtocolType,
        frameVersionNumber: actualFrameVersionNumber,
      );

      // Assert
      Uint8 expectedFrameCompressionType = Uint8.fromInt(actualFrameCompressionType.value);
      Uint8 expectedFrameEncodingType = Uint8.fromInt(actualFrameEncodingType.value);
      Uint8 expectedFrameProtocolType = Uint8.fromInt(actualFrameProtocolType.value);
      Uint8 expectedFrameVersionNumber = Uint8.fromInt(actualFrameVersionNumber.value);

      Uint32FrameProtocolID expectedFrameProtocolID = Uint32FrameProtocolID(
        frameCompressionType: expectedFrameCompressionType,
        frameEncodingType: expectedFrameEncodingType,
        frameProtocolType: expectedFrameProtocolType,
        frameVersionNumber: expectedFrameVersionNumber,
      );

      expect(actualFrameProtocolID, expectedFrameProtocolID);
    });
  });

  group('Test of Uint32FrameProtocolID.fromBytes()', () {
    test('Should parse Uint32FrameProtocolID correctly from given bytes', () {
      // Arrange
      Uint8List bytes = Uint8List.fromList(<int>[
        FrameCompressionType.noCompression.value,
        FrameEncodingType.defaultMethod.value,
        FrameProtocolType.rawDataTransfer.value,
        FrameVersionNumber.firstDefault.value,
      ]);

      // Act
      UintReminder<Uint32FrameProtocolID> actualFrameProtocolID = Uint32FrameProtocolID.fromBytes(bytes);

      // Assert
      Uint32FrameProtocolID expectedFrameProtocolID = Uint32FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );

      expect(actualFrameProtocolID.value, expectedFrameProtocolID);
    });
  });
}
