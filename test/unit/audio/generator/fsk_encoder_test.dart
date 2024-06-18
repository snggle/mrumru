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
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400], <int>[400], <int>[400], <int>[400], <int>[400], <int>[600], <int>[600], <int>[400], <int>[400], <int>[1000], <int>[400], <int>[600], <int>[400], <int>[1000], <int>[400], <int>[800],<int> [400],<int> [1000],<int> [400], <int>[1000], <int>[400],<int> [1000],<int> [600],<int> [400],<int> [800],<int> [400],<int> [400],<int> [600], <int>[400],<int> [400], <int>[400],<int> [600],<int> [400], <int>[600], <int>[600], <int>[400],<int> [400], <int>[1000],<int> [600], <int>[600], <int>[400], <int>[1000], <int>[600],<int> [800], <int>[400], <int>[1000],<int> [600],<int> [1000], <int>[400], <int>[1000],<int> [800], <int>[400],<int> [1000],<int> [400], <int>[1000],<int> [1000], <int>[900, 1100]] ;
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
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1600], <int>[400, 1600], <int>[400, 1800], <int>[600, 1600],<int> [400, 2200],<int> [400, 1800],<int> [400, 2200],<int> [400, 2000],<int> [400, 2200], <int>[400, 2200],<int> [400, 2200],<int> [600, 1600],<int> [800, 1600],<int> [400, 1800], <int>[400, 1600], <int>[400, 1800], <int>[400, 1800], <int>[600, 1600],<int> [400, 2200], <int>[600, 1800],<int> [400, 2200],<int> [600, 2000],<int> [400, 2200], <int>[600, 2200], <int>[400, 2200],<int> [800, 1600],<int> [1000, 1600], <int>[1000, 2200], <int>[900, 1100]];
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
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1600, 2800, 4000],<int> [400, 1800, 3000, 4000],<int> [400, 2200, 2800, 4200], <int>[400, 2200, 2800, 4400],<int> [400, 2200, 2800, 4600], <int>[400, 2200, 3000, 4000],<int> [800, 1600, 2800, 4200], <int>[400, 1600, 2800, 4200],<int> [400, 1800, 3000, 4000],<int> [400, 2200, 3000, 4200], <int>[400, 2200, 3000, 4400], <int>[400, 2200, 3000, 4600], <int>[400, 2200, 3200, 4000], <int>[1000, 1600, 3400, 4600], <int>[900, 1100]];
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
      List<List<int>> expectedFrequencies = <List<int>>[<int>[500, 700], <int>[400, 1600, 2800, 4000, 5200, 6600, 7800, 8800], <int>[400, 2200, 2800, 4200, 5200, 7000, 7600, 9200], <int>[400, 2200, 2800, 4600, 5200, 7000, 7800, 8800], <int>[800, 1600, 2800, 4200, 5200, 6400, 7600, 9000], <int>[400, 1800, 3000, 4000, 5200, 7000, 7800, 9000], <int>[400, 2200, 3000, 4400, 5200, 7000, 7800, 9400],<int> [400, 2200, 3200, 4000, 5800, 6400, 8200, 9400], <int>[900, 1100]];
      // @formatter:on

      expect(actualFrequencies, expectedFrequencies);
    });
  });
}
