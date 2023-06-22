import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/models/frame_collection_model.dart';

void main() {
  final FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
  final FrameCollectionModel actualFrameCollectionModel = FrameCollectionModel(<FrameModel>[
    FrameModel(frameIndex: 0, framesCount: 20, rawData: '1234', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 1, framesCount: 20, rawData: '5678', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 2, framesCount: 20, rawData: '9:;<', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 3, framesCount: 20, rawData: '=>?@', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 4, framesCount: 20, rawData: 'ABCD', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 5, framesCount: 20, rawData: 'EFGH', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 6, framesCount: 20, rawData: 'IJKL', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 7, framesCount: 20, rawData: 'MNOP', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 8, framesCount: 20, rawData: 'QRST', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 9, framesCount: 20, rawData: 'UVWX', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 10, framesCount: 20, rawData: 'YZ[]', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 11, framesCount: 20, rawData: '^_`a', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 12, framesCount: 20, rawData: 'bcde', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 13, framesCount: 20, rawData: 'fghi', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 14, framesCount: 20, rawData: 'jklm', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 15, framesCount: 20, rawData: 'nopq', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 16, framesCount: 20, rawData: 'rstu', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 17, framesCount: 20, rawData: 'vwxy', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 18, framesCount: 20, rawData: 'z{|}', frameSettings: actualFrameSettingsModel),
    FrameModel(frameIndex: 19, framesCount: 20, rawData: '~', frameSettings: actualFrameSettingsModel)
  ]);

  group('Tests of FrameCollectionModel.binaryFrames', () {
    test('Should return [binary string list] representing encoded rawData from each frames', () {
      // Act
      List<String> actualBinaryFrames = actualFrameCollectionModel.binaryFrames;

      // Assert
      List<String> expectedBinaryFrames = <String>[
        '00000000000101000011000100110010001100110011010010000001',
        '00000001000101000011010100110110001101110011100011001111',
        '00000010000101000011100100111010001110110011110011100111',
        '00000011000101000011110100111110001111110100000010000111',
        '00000100000101000100000101000010010000110100010011001011',
        '00000101000101000100010101000110010001110100100010111110',
        '00000110000101000100100101001010010010110100110011000111',
        '00000111000101000100110101001110010011110101000010000011',
        '00001000000101000101000101010010010100110101010011100000',
        '00001001000101000101010101010110010101110101100011011011',
        '00001010000101000101100101011010010110110101110111010001',
        '00001011000101000101111001011111011000000110000111101001',
        '00001100000101000110001001100011011001000110010111100000',
        '00001101000101000110011001100111011010000110100110101110',
        '00001110000101000110101001101011011011000110110110011111',
        '00001111000101000110111001101111011100000111000101100100',
        '00010000000101000111001001110011011101000111010111111111',
        '00010001000101000111011001110111011110000111100110001011',
        '00010010000101000111101001111011011111000111110111011101',
        '00010011000101000000000000000000000000000111111010011001'
      ];
      expect(actualBinaryFrames, expectedBinaryFrames);
    });
  });

  group('Tests of FrameCollectionModel.mergedBinaryFrames', () {
    test('Should return [binary string] representing merged and encoded rawData from each frames', () {
      // Act
      String actualString = actualFrameCollectionModel.mergedBinaryFrames;

      // Assert
      String expectedString =
          '0000000000010100001100010011001000110011001101001000000100000001000101000011010100110110001101110011100011001111000000100001010000111001001110100011101100111100111001110000001100010100001111010011111000111111010000001000011100000100000101000100000101000010010000110100010011001011000001010001010001000101010001100100011101001000101111100000011000010100010010010100101001001011010011001100011100000111000101000100110101001110010011110101000010000011000010000001010001010001010100100101001101010100111000000000100100010100010101010101011001010111010110001101101100001010000101000101100101011010010110110101110111010001000010110001010001011110010111110110000001100001111010010000110000010100011000100110001101100100011001011110000000001101000101000110011001100111011010000110100110101110000011100001010001101010011010110110110001101101100111110000111100010100011011100110111101110000011100010110010000010000000101000111001001110011011101000111010111111111000100010001010001110110011101110111100001111001100010110001001000010100011110100111101101111100011111011101110100010011000101000000000000000000000000000111111010011001';
      expect(actualString, expectedString);
    });
  });

  group('Tests of FrameCollectionModel.mergedRawData', () {
    test('Should return [raw string] representing merged rawData from each frames', () {
      // Act
      String actualString = actualFrameCollectionModel.mergedRawData;

      // Assert
      String expectedString = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';
      expect(actualString, expectedString);
    });
  });
}
