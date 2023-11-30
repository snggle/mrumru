import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  group('Test of AudioSettingsModel.maxFrequency', () {
    test('Should return max frequency value (600) for bitsPerFrequency (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxFrequency;

      // Assert
      int expectedMaxFrequency = 600;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (1000) for bitsPerFrequency (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxFrequency;

      // Assert
      int expectedMaxFrequency = 1000;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (3400) for bitsPerFrequency (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxFrequency;

      // Assert
      int expectedMaxFrequency = 3400;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (51400) for bitsPerFrequency (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxFrequency;

      // Assert
      int expectedMaxFrequency = 51400;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });
  });

  group('Test of AudioSettingsModel.possibleFrequencies', () {
    test('Should return list of possible frequencies for bitsPerFrequency (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000, 5200, 5400, 5600, 5800, 6000, 6200, 6400, 6600, 6800, 7000, 7200, 7400, 7600, 7800, 8000, 8200, 8400, 8600, 8800, 9000, 9200, 9400, 9600, 9800, 10000, 10200, 10400, 10600, 10800, 11000, 11200, 11400, 11600, 11800, 12000, 12200, 12400, 12600, 12800, 13000, 13200, 13400, 13600, 13800, 14000, 14200, 14400, 14600, 14800, 15000, 15200, 15400, 15600, 15800, 16000, 16200, 16400, 16600, 16800, 17000, 17200, 17400, 17600, 17800, 18000, 18200, 18400, 18600, 18800, 19000, 19200, 19400, 19600, 19800, 20000, 20200, 20400, 20600, 20800, 21000, 21200, 21400, 21600, 21800, 22000, 22200, 22400, 22600, 22800, 23000, 23200, 23400, 23600, 23800, 24000, 24200, 24400, 24600, 24800, 25000, 25200, 25400, 25600, 25800, 26000, 26200, 26400, 26600, 26800, 27000, 27200, 27400, 27600, 27800, 28000, 28200, 28400, 28600, 28800, 29000, 29200, 29400, 29600, 29800, 30000, 30200, 30400, 30600, 30800, 31000, 31200, 31400, 31600, 31800, 32000, 32200, 32400, 32600, 32800, 33000, 33200, 33400, 33600, 33800, 34000, 34200, 34400, 34600, 34800, 35000, 35200, 35400, 35600, 35800, 36000, 36200, 36400, 36600, 36800, 37000, 37200, 37400, 37600, 37800, 38000, 38200, 38400, 38600, 38800, 39000, 39200, 39400, 39600, 39800, 40000, 40200, 40400, 40600, 40800, 41000, 41200, 41400, 41600, 41800, 42000, 42200, 42400, 42600, 42800, 43000, 43200, 43400, 43600, 43800, 44000, 44200, 44400, 44600, 44800, 45000, 45200, 45400, 45600, 45800, 46000, 46200, 46400, 46600, 46800, 47000, 47200, 47400, 47600, 47800, 48000, 48200, 48400, 48600, 48800, 49000, 49200, 49400, 49600, 49800, 50000, 50200, 50400, 50600, 50800, 51000, 51200, 51400];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });
}
