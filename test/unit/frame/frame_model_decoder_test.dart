import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/frame/frame_model_decoder.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';
import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/models/frame_settings_model.dart';

void main() {
  late FrameModelDecoder actualFrameModelDecoder;
  late FrameSettingsModel actualFrameSettings;

  setUp(() {
    actualFrameSettings = FrameSettingsModel.withDefaults();
    actualFrameModelDecoder = FrameModelDecoder(framesSettingsModel: actualFrameSettings);
  });

  group('Tests of FrameModelProcessor.decodeBinaryData()', () {
    test('Should return [FrameCollectionModel] from given binary data', () {
      // Arrange
      String actualRawData =
          '0000000000010100001100010011001000110011001101001000000100000001000101000011010100110110001101110011100011001111000000100001010000111001001110100011101100111100111001110000001100010100001111010011111000111111010000001000011100000100000101000100000101000010010000110100010011001011000001010001010001000101010001100100011101001000101111100000011000010100010010010100101001001011010011001100011100000111000101000100110101001110010011110101000010000011000010000001010001010001010100100101001101010100111000000000100100010100010101010101011001010111010110001101101100001010000101000101100101011010010110110101110111010001000010110001010001011110010111110110000001100001111010010000110000010100011000100110001101100100011001011110000000001101000101000110011001100111011010000110100110101110000011100001010001101010011010110110110001101101100111110000111100010100011011100110111101110000011100010110010000010000000101000111001001110011011101000111010111111111000100010001010001110110011101110111100001111001100010110001001000010100011110100111101101111100011111011101110100010011000101000000000000000000000000000111111010011001';
      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameModelDecoder.decodeBinaryData(actualRawData);

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
