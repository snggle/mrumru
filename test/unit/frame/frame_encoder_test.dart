import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_encoder.dart';
import 'package:mrumru/src/shared/models/frame/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/enums/compression_method.dart';
import 'package:mrumru/src/shared/utils/enums/encoding_method.dart';

import 'package:mrumru/src/shared/utils/enums/protocol_type.dart';
import 'package:mrumru/src/shared/utils/enums/version_number.dart';

void main() {
  group('Tests of FrameEncoder.buildFrameCollection()', () {
    test('Should [return FrameCollectionModel] from given raw data', () {
      // Arrange
      FrameEncoder actualFrameEncoder = FrameEncoder(frameDataBytesLength: 32);
      Uint8List actualBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameEncoder.buildFrameCollection(actualBytes);

      // Assert
      //@formatter:off
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrame>[
        MetadataFrame.fromValues(
          frameIndex: 0,
          frameProtocolID: FrameProtocolID.fromValues(
            compressionMethod: CompressionMethod.noCompression,
            encodingMethod: EncodingMethod.defaultMethod,
            protocolType: ProtocolType.rawDataTransfer,
            versionNumber: VersionNumber.firstDefault,
          ),
          sessionId: base64Decode('AQIDBA=='),
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
            DataFrame.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
        DataFrame.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),
      ]);
      //@formatter:on
      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
