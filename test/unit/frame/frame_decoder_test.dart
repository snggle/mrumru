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
        '00000001000000100000001100000100010110011100011000000001111010001001111000100101',
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
          data: Uint8List.fromList(<int>[]),
          dataFrames: <DataFrame>[
            DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
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
        data: Uint8List.fromList(<int>[]),
        dataFrames: <DataFrame>[
          DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
          DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
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
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
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
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from partially received binary data (contains Metadata and DataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '000000000000001000000000000011110101000101010010010100110101010001010101010101100101',
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
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (contains Metadata, DataFrame and last DataFrame)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '011101011000010110010101101001011011010111010101111001011111011000001111110100101100',
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
            DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
        DataFrame.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
      ]);
      DataFrame expectedLastDataFrame = DataFrame.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g'));

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
