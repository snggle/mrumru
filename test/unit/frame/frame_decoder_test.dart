import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_decoder.dart';
import 'package:mrumru/src/shared/enums/compression_method.dart';
import 'package:mrumru/src/shared/enums/encoding_method.dart';
import 'package:mrumru/src/shared/enums/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

void main() {
  MetadataFrame? actualMetadataFrame;
  DataFrame? actualLastDataFrame;

  FrameDecoder actualFrameDecoder = FrameDecoder(
    onFirstFrameDecoded: (MetadataFrame metadataFrame) => actualMetadataFrame = metadataFrame,
    onLastFrameDecoded: (DataFrame dataFrame) => actualLastDataFrame = dataFrame,
  );

  group('Tests of FrameDecoder process', () {
    test('Should [return EMPTY FrameCollectionModel] from partially received binary data', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000000000000000000000000000000000000000000001000000000000000000000000000000001',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = const FrameCollectionModel(<ABaseFrame>[]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (received MetadataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000001000000100000001100000100100110001101001011100011011110101011110101011110',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
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
          data: Uint8List(0),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
          ],
        ),
      ]);
      MetadataFrame expectedMetadataFrame = MetadataFrame.fromValues(
        frameIndex: 0,
        frameProtocolID: FrameProtocolID.fromValues(
          compressionMethod: CompressionMethod.noCompression,
          encodingMethod: EncodingMethod.defaultMethod,
          protocolType: ProtocolType.rawDataTransfer,
          versionNumber: VersionNumber.firstDefault,
        ),
        sessionId: base64Decode('AQIDBA=='),
        data: Uint8List(0),
        dataFrames: <DataFrame>[
          DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
          DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
        ],
      );

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
      expect(actualMetadataFrame, expectedMetadataFrame);
    });

    test('Should [return FrameCollectionModel] from partially received binary data (contains MetadataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000000000000010000000000100000001100010011001000110011001101000011010100110110001101110011100000111001001110100011101100111100001111010011111000111111',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
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
          data: Uint8List(0),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
          ],
        ),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (contains Metadata and DataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '01000000010000010100001001000011010001000100010101000110010001110100100001001001010010100100101101001100010011010100111001001111010100001110000001110101',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
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
          data: Uint8List(0),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from partially received binary data (contains Metadata and DataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000000000000100000000000100000010100010101001001010011010101000101010101010110010101110101100001011001010110100101101101011101010111100101111101100000',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
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
          data: Uint8List(0),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (contains Metadata, DataFrame and last DataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '01100001011000100110001101100100011001010110011001100111011010000110100101101010011010110110110001101101011011100110111101110000011100010111111111100101',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
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
          data: Uint8List(0),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
      ]);
      DataFrame expectedLastDataFrame = DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE='));

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
      expect(actualLastDataFrame, expectedLastDataFrame);
    });

    test('Should [return EMPTY FrameCollectionModel] after data cleared', () {
      // Arrange
      actualFrameDecoder.clear();

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = const FrameCollectionModel(<ABaseFrame>[]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
