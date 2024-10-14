import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_encoder.dart';
import 'package:mrumru/src/shared/models/frame/frame_compression_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_encoding_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_type.dart';
import 'package:mrumru/src/shared/models/frame/frame_version_number.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Tests of FrameEncoder.buildFrameCollection()', () {
    test('Should [return FrameCollectionModel] from given raw data', () {
      // Arrange
      FrameEncoder actualFrameEncoder = FrameEncoder(frameDataBytesLength: 32);
      Uint8List actualBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');
      FrameProtocolID actualFrameProtocolID = FrameProtocolID(
        frameCompressionType: Uint8.fromInt(FrameCompressionType.noCompression.value),
        frameEncodingType: Uint8.fromInt(FrameEncodingType.defaultMethod.value),
        frameProtocolType: Uint8.fromInt(FrameProtocolType.rawDataTransfer.value),
        frameVersionNumber: Uint8.fromInt(FrameVersionNumber.firstDefault.value),
      );

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameEncoder.buildFrameCollection(actualBytes);

      // Assert
      //@formatter:off
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrame>[
        MetadataFrame(
          frameIndex: Uint16(Uint8List.fromList(<int>[0, 0])),
          frameLength: Uint16(Uint8List.fromList(<int>[0, 0])),
          framesCount: Uint16(Uint8List.fromList(<int>[0, 3])),
          frameProtocolID: actualFrameProtocolID,
          sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
          compositeChecksum: Uint32(Uint8List.fromList(<int>[214, 197, 141, 48])),
          data: UintDynamic(Uint8List.fromList(<int>[]), 0),
          frameChecksum: Uint16(Uint8List.fromList(<int>[77, 19])),
        ),
        DataFrame(
            frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
          frameLength: Uint16(Uint8List.fromList(<int>[0, 32])),
            data: UintDynamic(Uint8List.fromList(<int>[49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
              61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80]),256),
            frameChecksum: Uint16(Uint8List.fromList(<int>[224, 117])) ),
        DataFrame(
            frameIndex:Uint16(Uint8List.fromList(<int>[0, 2])),
            frameLength: Uint16(Uint8List.fromList(<int>[0, 32])),
            data: UintDynamic(Uint8List.fromList(<int>[81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 93,
              94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113]),
                256),
            frameChecksum: Uint16(Uint8List.fromList(<int>[127, 229]),)),
        DataFrame(
            frameIndex:Uint16(Uint8List.fromList(<int>[0, 3])),
            frameLength:Uint16(Uint8List.fromList(<int>[0, 13])),
            data:UintDynamic(Uint8List.fromList(<int>[114, 115, 116, 117, 118, 119, 120, 121, 122, 123,
              124, 125, 126]), 104),
            frameChecksum:  Uint16(Uint8List.fromList(<int>[70, 194])),)
      ]);
      //@formatter:on
      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
