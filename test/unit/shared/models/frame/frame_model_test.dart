import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  late FrameSettingsModel actualFrameSettings;

  setUp(() => actualFrameSettings = FrameSettingsModel.withDefaults());

  group('Tests of FrameModel.fromBinaryString()', () {
    test('Should return [FrameModel] from given binary string', () {
      // Arrange
      String actualBinaryString = '00000000000000010011000100110010001100110011010010000001';

      // Act
      FrameModel actualDecodedFrameModel = FrameModel.fromBinaryString(actualBinaryString);

      // Assert
      FrameModel expectedDecodedFrameModel = FrameModel(frameIndex: 0, framesCount: 1, rawData: '1234', frameSettings: actualFrameSettings);
      expect(actualDecodedFrameModel, expectedDecodedFrameModel);
    });
  });

  group('Tests of FrameModel.binaryString', () {
    test('Should return [binary string] from given FrameModel', () {
      // Arrange
      FrameModel actualFrameModel = FrameModel(frameIndex: 0, framesCount: 17, rawData: '1234', frameSettings: actualFrameSettings);

      // Act
      String actualBinaryString = actualFrameModel.binaryString;

      // Assert
      String expectedBinaryString = '00000000000100010011000100110010001100110011010010000001';
      expect(actualBinaryString, expectedBinaryString);
    });
  });

  group('Tests of FrameModel.binaryList', () {
    test('Should return list of elements from FrameModel as string', () {
      // Arrange
      FrameModel actualFrameModel = FrameModel(frameIndex: 0, framesCount: 17, rawData: '1234', frameSettings: actualFrameSettings);

      // Act
      List<String> actualBinaryStringList = actualFrameModel.binaryList;

      // Assert
      List<String> expectedBinaryStringList = <String>['00000000', '00010001', '00110001001100100011001100110100', '10000001'];
      expect(actualBinaryStringList, expectedBinaryStringList);
    });
  });

  group('Tests of FrameModel.calculateTransferWavLength()', () {
    test('Should [return transfer wav length] from given [frame model] and [audio settings model]', () {
      // Arrange
      AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
      FrameModel actualFrameModel = FrameModel(frameIndex: 0, framesCount: 10, rawData: '1', frameSettings: actualFrameSettings);

      // Act
      int actualTransferWavLength = actualFrameModel.calculateTransferWavLength(audioSettingsModel);

      // Assert
      int expectedTransferWavLength = 108416000000;

      expect(actualTransferWavLength, expectedTransferWavLength);
    });
  });
}
