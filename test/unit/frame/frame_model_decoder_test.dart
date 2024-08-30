import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';

void main() {
  FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
  FrameModelDecoder actualFrameModelDecoder = FrameModelDecoder(framesSettingsModel: actualFrameSettingsModel);

  // @formatter:off
  List<String> actualFirstChunkedData = <String>['0000', '0000', '0000', '0010', '0011', '0001', '0011', '0010', '0011', '0011', '0011', '0100', '1000', '0001'];
  List<String> actualSecondChunkedData = <String>['0000', '0001', '0000', '0010', '0011', '0101', '0011', '0110', '0011', '0111', '0011', '1000', '1100', '1111'];
  // @formatter:on

  group('Tests of FrameModelDecoder process', () {
    test('Should [return FrameCollectionModel] from given [1st binary data]', () {
      //Arrange
      actualFrameModelDecoder.addBinaries(actualFirstChunkedData);

      //Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameModelDecoder.decodedContent;

      //Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<FrameModel>[
        FrameModel(frameIndex: 0, framesCount: 2, rawData: '1234', frameSettings: actualFrameSettingsModel),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from given [2nd binary data]', () {
      // Arrange
      actualFrameModelDecoder.addBinaries(actualSecondChunkedData);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameModelDecoder.decodedContent;

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<FrameModel>[
        FrameModel(frameIndex: 0, framesCount: 2, rawData: '1234', frameSettings: actualFrameSettingsModel),
        FrameModel(frameIndex: 1, framesCount: 2, rawData: '5678', frameSettings: actualFrameSettingsModel),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [clear FrameModelCollection] containing FrameModels', () {
      // Act
      actualFrameModelDecoder.clear();

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = const FrameCollectionModel(<FrameModel>[]);
      expect(actualFrameModelDecoder.decodedContent, expectedFrameCollectionModel);
    });
  });
}
