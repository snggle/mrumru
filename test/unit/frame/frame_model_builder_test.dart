import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_model_builder.dart';
import 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

void main() {
  late FrameModelBuilder actualFrameBuilder;
  late String actualRawData;
  late FrameSettingsModel actualFrameSettings = FrameSettingsModel.withDefaults();

  setUp(() {
    actualFrameBuilder = FrameModelBuilder(frameSettingsModel: actualFrameSettings);
    actualRawData = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
    actualFrameSettings = FrameSettingsModel.withDefaults();
  });

  group('Tests of FrameModelBuilder.buildFrameCollection()', () {
    test('Should correctly split and generate frames from given raw data', () {
      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameBuilder.buildFrameCollection(actualRawData);

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<FrameModel>[
        FrameModel(frameIndex: 0, framesCount: 20, rawData: '1234', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 1, framesCount: 20, rawData: '5678', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 2, framesCount: 20, rawData: '9:;<', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 3, framesCount: 20, rawData: '=>?@', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 4, framesCount: 20, rawData: 'ABCD', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 5, framesCount: 20, rawData: 'EFGH', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 6, framesCount: 20, rawData: 'IJKL', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 7, framesCount: 20, rawData: 'MNOP', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 8, framesCount: 20, rawData: 'QRST', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 9, framesCount: 20, rawData: 'UVWX', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 10, framesCount: 20, rawData: 'YZ[]', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 11, framesCount: 20, rawData: '^_`a', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 12, framesCount: 20, rawData: 'bcde', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 13, framesCount: 20, rawData: 'fghi', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 14, framesCount: 20, rawData: 'jklm', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 15, framesCount: 20, rawData: 'nopq', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 16, framesCount: 20, rawData: 'rstu', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 17, framesCount: 20, rawData: 'vwxy', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 18, framesCount: 20, rawData: 'z{|}', frameSettings: actualFrameSettings),
        FrameModel(frameIndex: 19, framesCount: 20, rawData: '~', frameSettings: actualFrameSettings)
      ]);
      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}
