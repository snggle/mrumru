import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/dtos/frame_protocol_id.dart';
import 'package:mrumru/src/shared/enums/compression_method.dart';
import 'package:mrumru/src/shared/enums/encoding_method.dart';
import 'package:mrumru/src/shared/enums/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of FrameProtocolID.fromValues()', () {
    test('Should [return FrameProtocolID] created from given values', () {
      // Act
      FrameProtocolID actualFrameProtocolID = FrameProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.defaultMethod,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      );

      // Assert
      FrameProtocolID expectedFrameProtocolID = FrameProtocolID(
        compressionMethod: Uint8.fromInt(0),
        encodingMethod: Uint8.fromInt(0),
        protocolType: Uint8.fromInt(0),
        versionNumber: Uint8.fromInt(1),
      );

      expect(actualFrameProtocolID, expectedFrameProtocolID);
    });
  });

  group('Test of FrameProtocolID.fromBytes()', () {
    test('Should [return UintReminder] containing FrameProtocolID from given bytes when [reminder EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 1]);

      // Act
      UintReminder<FrameProtocolID> actualFrameProtocolIDReminder = FrameProtocolID.fromBytes(actualBytes);

      // Assert
      UintReminder<FrameProtocolID> expectedFrameProtocolIDReminder = UintReminder<FrameProtocolID>(
        FrameProtocolID.fromValues(
          compressionMethod: CompressionMethod.noCompression,
          encodingMethod: EncodingMethod.defaultMethod,
          protocolType: ProtocolType.rawDataTransfer,
          versionNumber: VersionNumber.firstDefault,
        ),
        Uint8List.fromList(<int>[]),
      );

      expect(actualFrameProtocolIDReminder, expectedFrameProtocolIDReminder);
    });

    test('Should [return UintReminder] containing FrameProtocolID from given bytes when [reminder NOT EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 1, 60, 80, 90, 100]);

      // Act
      UintReminder<FrameProtocolID> actualFrameProtocolIDReminder = FrameProtocolID.fromBytes(actualBytes);

      // Assert
      UintReminder<FrameProtocolID> expectedFrameProtocolIDReminder = UintReminder<FrameProtocolID>(
        FrameProtocolID.fromValues(
          compressionMethod: CompressionMethod.noCompression,
          encodingMethod: EncodingMethod.defaultMethod,
          protocolType: ProtocolType.rawDataTransfer,
          versionNumber: VersionNumber.firstDefault,
        ),
        Uint8List.fromList(<int>[60, 80, 90, 100]),
      );

      expect(actualFrameProtocolIDReminder, expectedFrameProtocolIDReminder);
    });
  });

  group('Test of FrameProtocolID.toBytes()', () {
    test('Should [return bytes] representing FrameProtocolID', () {
      // Arrange
      FrameProtocolID actualFrameProtocolID = FrameProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.defaultMethod,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      );

      // Act
      Uint8List actualBytes = actualFrameProtocolID.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 1]);

      expect(actualBytes, expectedBytes);
    });
  });
}
