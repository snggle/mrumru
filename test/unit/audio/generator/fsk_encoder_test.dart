import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/generator/fsk_encoder.dart';

void main() {
  String actualBinaryData = '0000000000010100001100010011001000110011001101001000000100000001000101000011010100110110001101110011100011001111';

  group('Test of FskEncoder.buildFrequencies()', () {
    test('Should [generate samples] and correctly decode them if [chunksCount == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);
      FskEncoder actualFskEncoder = FskEncoder(actualAudioSettingsModel);

      // Act
      List<List<int>> actualFrequencies = actualFskEncoder.buildFrequencies(actualBinaryData);

      // Assert
      // @formatter:off
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400], <int>[400], <int>[400], <int>[400], <int>[400], <int>[602], <int>[602], <int>[400], <int>[400], <int>[1003], <int>[400], <int>[602], <int>[400], <int>[1003], <int>[400], <int>[802], <int>[400], <int>[1003], <int>[400], <int>[1003], <int>[400], <int>[1003], <int>[602], <int>[400], <int>[802], <int>[400], <int>[400], <int>[602], <int>[400], <int>[400], <int>[400], <int>[602], <int>[400], <int>[602], <int>[602], <int>[400], <int>[400], <int>[1003], <int>[602], <int>[602], <int>[400], <int>[1003], <int>[602], <int>[802], <int>[400], <int>[1003], <int>[602], <int>[1003], <int>[400], <int>[1003], <int>[802], <int>[400], <int>[1003], <int>[400], <int>[1003], <int>[1003], <int>[900, 1100]] ;
      // @formatter:on
      expect(actualFrequencies, expectedFrequencies);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);
      FskEncoder actualFskEncoder = FskEncoder(actualAudioSettingsModel);

      // Act
      List<List<int>> actualFrequencies = actualFskEncoder.buildFrequencies(actualBinaryData);

      // Assert
      // @formatter:off
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1204], <int>[400, 1204], <int>[400, 1404], <int>[602, 1204], <int>[400, 1805], <int>[400, 1404], <int>[400, 1805], <int>[400, 1605], <int>[400, 1805], <int>[400, 1805], <int>[400, 1805], <int>[602, 1204], <int>[802, 1204], <int>[400, 1404], <int>[400, 1204], <int>[400, 1404], <int>[400, 1404], <int>[602, 1204], <int>[400, 1805], <int>[602, 1404], <int>[400, 1805], <int>[602, 1605], <int>[400, 1805], <int>[602, 1805], <int>[400, 1805], <int>[802, 1204], <int>[1003, 1204], <int>[1003, 1805], <int>[900, 1100]];
      // @formatter:on
      expect(actualFrequencies, expectedFrequencies);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);
      FskEncoder actualFskEncoder = FskEncoder(actualAudioSettingsModel);

      // Act
      List<List<int>> actualFrequencies = actualFskEncoder.buildFrequencies(actualBinaryData);

      // Assert
      // @formatter:off
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1204, 2006, 2808], <int>[400, 1404, 2206, 2808], <int>[400, 1805, 2006, 3009], <int>[400, 1805, 2006, 3209], <int>[400, 1805, 2006, 3410], <int>[400, 1805, 2206, 2808], <int>[802, 1204, 2006, 3009], <int>[400, 1204, 2006, 3009], <int>[400, 1404, 2206, 2808], <int>[400, 1805, 2206, 3009], <int>[400, 1805, 2206, 3209], <int>[400, 1805, 2206, 3410], <int>[400, 1805, 2407, 2808], <int>[1003, 1204, 2608, 3410], <int>[900, 1100]];
      // @formatter:on

      expect(actualFrequencies, expectedFrequencies);
    });

    test('Should [generate samples] and correctly decode them if [chunksCount == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);
      FskEncoder actualFskEncoder = FskEncoder(actualAudioSettingsModel);

      // Act
      List<List<int>> actualFrequencies = actualFskEncoder.buildFrequencies(actualBinaryData);

      // Assert
      // @formatter:off
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1204, 2006, 2808, 3611, 4614, 5416, 6018], <int>[400, 1805, 2006, 3009, 3611, 5015, 5215, 6419], <int>[400, 1805, 2006, 3410, 3611, 5015, 5416, 6018], <int>[802, 1204, 2006, 3009, 3611, 4413, 5215, 6218], <int>[400, 1404, 2206, 2808, 3611, 5015, 5416, 6218], <int>[400, 1805, 2206, 3209, 3611, 5015, 5416, 6619], <int>[400, 1805, 2407, 2808, 4212, 4413, 5817, 6619], <int>[900, 1100]];
      // @formatter:on

      expect(actualFrequencies, expectedFrequencies);
    });
  });
}
