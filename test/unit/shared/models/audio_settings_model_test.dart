import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  group('Tests of AudioSettingsModel.frequenciesCountPerChunk getter', () {
    test('Should [return frequencies amount] for [bitsPerFrequency == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      int actualFrequenciesCountPerChunk = actualAudioSettingsModel.frequenciesCountPerChunk;

      // Assert
      int expectedFrequenciesCountPerChunk = 2;

      expect(actualFrequenciesCountPerChunk, expectedFrequenciesCountPerChunk);
    });

    test('Should [return frequencies amount] for [bitsPerFrequency == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      int actualFrequenciesCountPerChunk = actualAudioSettingsModel.frequenciesCountPerChunk;

      // Assert
      int expectedFrequenciesCountPerChunk = 4;

      expect(actualFrequenciesCountPerChunk, expectedFrequenciesCountPerChunk);
    });

    test('Should [return frequencies amount] for [bitsPerFrequency == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      int actualFrequenciesCountPerChunk = actualAudioSettingsModel.frequenciesCountPerChunk;

      // Assert
      int expectedFrequenciesCountPerChunk = 16;

      expect(actualFrequenciesCountPerChunk, expectedFrequenciesCountPerChunk);
    });

    test('Should [return frequencies amount] for [bitsPerFrequency == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      int actualFrequenciesCountPerChunk = actualAudioSettingsModel.frequenciesCountPerChunk;

      // Assert
      int expectedFrequenciesCountPerChunk = 256;

      expect(actualFrequenciesCountPerChunk, expectedFrequenciesCountPerChunk);
    });
  });

  group('Tests of AudioSettingsModel.allPossibleFrequencies getter', () {
    test('Should [return possible frequencies] for [chunksCount == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 16]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 32]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 32);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750, 3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150, 4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750, 4800, 4850, 4900, 4950, 5000, 5050, 5100, 5150, 5200, 5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600, 5650, 5700, 5750, 5800, 5850, 5900, 5950, 6000, 6050, 6100, 6150, 6200, 6250, 6300, 6350, 6400, 6450, 6500, 6550, 6600, 6650, 6700, 6750];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.allPossibleFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750, 3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150, 4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750, 4800, 4850, 4900, 4950, 5000, 5050, 5100, 5150, 5200, 5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600, 5650, 5700, 5750, 5800, 5850, 5900, 5950, 6000, 6050, 6100, 6150, 6200, 6250, 6300, 6350, 6400, 6450, 6500, 6550, 6600, 6650, 6700, 6750, 6800, 6850, 6900, 6950, 7000, 7050, 7100, 7150, 7200, 7250, 7300, 7350, 7400, 7450, 7500, 7550, 7600, 7650, 7700, 7750, 7800, 7850, 7900, 7950, 8000, 8050, 8100, 8150, 8200, 8250, 8300, 8350, 8400, 8450, 8500, 8550, 8600, 8650, 8700, 8750, 8800, 8850, 8900, 8950, 9000, 9050, 9100, 9150, 9200, 9250, 9300, 9350, 9400, 9450, 9500, 9550, 9600, 9650, 9700, 9750, 9800, 9850, 9900, 9950, 10000, 10050, 10100, 10150, 10200, 10250, 10300, 10350, 10400, 10450, 10500, 10550, 10600, 10650, 10700, 10750, 10800, 10850, 10900, 10950, 11000, 11050, 11100, 11150, 11200, 11250, 11300, 11350, 11400, 11450, 11500, 11550, 11600, 11650, 11700, 11750, 11800, 11850, 11900, 11950, 12000, 12050, 12100, 12150, 12200, 12250, 12300, 12350, 12400, 12450, 12500, 12550, 12600, 12650, 12700, 12750, 12800, 12850, 12900, 12950, 13000, 13050, 13100, 13150];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Tests of AudioSettingsModel.possibleBaseFrequencies getter', () {
    test('Should [return possible frequencies] for [bitsPerFrequency == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [bitsPerFrequency == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [bitsPerFrequency == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for [bitsPerFrequency == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750, 3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150, 4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750, 4800, 4850, 4900, 4950, 5000, 5050, 5100, 5150, 5200, 5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600, 5650, 5700, 5750, 5800, 5850, 5900, 5950, 6000, 6050, 6100, 6150, 6200, 6250, 6300, 6350, 6400, 6450, 6500, 6550, 6600, 6650, 6700, 6750, 6800, 6850, 6900, 6950, 7000, 7050, 7100, 7150, 7200, 7250, 7300, 7350, 7400, 7450, 7500, 7550, 7600, 7650, 7700, 7750, 7800, 7850, 7900, 7950, 8000, 8050, 8100, 8150, 8200, 8250, 8300, 8350, 8400, 8450, 8500, 8550, 8600, 8650, 8700, 8750, 8800, 8850, 8900, 8950, 9000, 9050, 9100, 9150, 9200, 9250, 9300, 9350, 9400, 9450, 9500, 9550, 9600, 9650, 9700, 9750, 9800, 9850, 9900, 9950, 10000, 10050, 10100, 10150, 10200, 10250, 10300, 10350, 10400, 10450, 10500, 10550, 10600, 10650, 10700, 10750, 10800, 10850, 10900, 10950, 11000, 11050, 11100, 11150, 11200, 11250, 11300, 11350, 11400, 11450, 11500, 11550, 11600, 11650, 11700, 11750, 11800, 11850, 11900, 11950, 12000, 12050, 12100, 12150, 12200, 12250, 12300, 12350, 12400, 12450, 12500, 12550, 12600, 12650, 12700, 12750, 12800, 12850, 12900, 12950, 13000, 13050, 13100, 13150];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Tests of AudioSettingsModel.maxBaseFrequency getter', () {
    test('Should [return 600] for [bitsPerFrequency == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 450;

      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should [return 1000] for [bitsPerFrequency == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 550;

      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should [return 3400] for [bitsPerFrequency == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 1150;

      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should [return 51400] for [bitsPerFrequency == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 13150;

      expect(actualMaxFrequency, expectedMaxFrequency);
    });
  });

  group('Tests of AudioSettingsModel.possibleFrequenciesForChunks getter', () {
    test('Should [return possible frequencies] for chunks for [chunksCount == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      List<List<int>> expectedPossibleFrequencies = <List<int>>[
        <int>[400, 451, 501, 552]
      ];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      List<List<int>> expectedPossibleFrequencies = <List<int>>[
        <int>[400, 451, 501, 552],
        <int>[602, 652, 702, 752]
      ];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      List<List<int>> expectedPossibleFrequencies = <List<int>>[
        <int>[400, 451, 501, 552],
        <int>[602, 652, 702, 752],
        <int>[802, 853, 903, 953],
        <int>[1003, 1053, 1103, 1153]
      ];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      // @formatter:off
      List<List<int>> expectedPossibleFrequencies = <List<int>>[<int>[400, 451, 501, 552], <int>[602, 652, 702, 752], <int>[802, 853, 903, 953], <int>[1003, 1053, 1103, 1153], <int>[1204, 1254, 1304, 1354], <int>[1404, 1454, 1504, 1555], <int>[1605, 1655, 1705, 1755], <int>[1805, 1855, 1906, 1956]];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 16]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      // @formatter:off
      List<List<int>> expectedPossibleFrequencies = <List<int>>[<int>[400, 451, 501, 552], <int>[602, 652, 702, 752], <int>[802, 853, 903, 953], <int>[1003, 1053, 1103, 1153], <int>[1204, 1254, 1304, 1354], <int>[1404, 1454, 1504, 1555], <int>[1605, 1655, 1705, 1755], <int>[1805, 1855, 1906, 1956], <int>[2006, 2056, 2106, 2156], <int>[2206, 2257, 2307, 2357], <int>[2407, 2457, 2507, 2558], <int>[2608, 2658, 2708, 2758], <int>[2808, 2858, 2909, 2959], <int>[3009, 3059, 3109, 3159], <int>[3209, 3260, 3310, 3360], <int>[3410, 3460, 3510, 3560]];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 32]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 32);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      // @formatter:off
      List<List<int>> expectedPossibleFrequencies = <List<int>>[<int>[400, 451, 501, 552], <int>[602, 652, 702, 752], <int>[802, 853, 903, 953], <int>[1003, 1053, 1103, 1153], <int>[1204, 1254, 1304, 1354], <int>[1404, 1454, 1504, 1555], <int>[1605, 1655, 1705, 1755], <int>[1805, 1855, 1906, 1956], <int>[2006, 2056, 2106, 2156], <int>[2206, 2257, 2307, 2357], <int>[2407, 2457, 2507, 2558], <int>[2608, 2658, 2708, 2758], <int>[2808, 2858, 2909, 2959], <int>[3009, 3059, 3109, 3159], <int>[3209, 3260, 3310, 3360], <int>[3410, 3460, 3510, 3560], <int>[3611, 3661, 3711, 3761], <int>[3811, 3861, 3911, 3962], <int>[4012, 4062, 4112, 4162], <int>[4212, 4263, 4313, 4363], <int>[4413, 4463, 4513, 4563], <int>[4614, 4664, 4714, 4764], <int>[4814, 4864, 4914, 4965], <int>[5015, 5065, 5115, 5165], <int>[5215, 5265, 5316, 5366], <int>[5416, 5466, 5516, 5566], <int>[5616, 5667, 5717, 5767], <int>[5817, 5867, 5917, 5968], <int>[6018, 6068, 6118, 6168], <int>[6218, 6268, 6319, 6369], <int>[6419, 6469, 6519, 6569], <int>[6619, 6670, 6720, 6770] ];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunks for [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);

      // Act
      List<List<int>> actualPossibleFrequencies = actualAudioSettingsModel.possibleDynamicFrequenciesForChunks;

      // Assert
      // @formatter:off
      List<List<int>> expectedPossibleFrequencies = <List<int>>[<int>[400, 451, 501, 552], <int>[602, 652, 702, 752], <int>[802, 853, 903, 953], <int>[1003, 1053, 1103, 1153], <int>[1204, 1254, 1304, 1354], <int>[1404, 1454, 1504, 1555], <int>[1605, 1655, 1705, 1755], <int>[1805, 1855, 1906, 1956], <int>[2006, 2056, 2106, 2156], <int>[2206, 2257, 2307, 2357], <int>[2407, 2457, 2507, 2558], <int>[2608, 2658, 2708, 2758], <int>[2808, 2858, 2909, 2959], <int>[3009, 3059, 3109, 3159], <int>[3209, 3260, 3310, 3360], <int>[3410, 3460, 3510, 3560], <int>[3611, 3661, 3711, 3761], <int>[3811, 3861, 3911, 3962], <int>[4012, 4062, 4112, 4162], <int>[4212, 4263, 4313, 4363], <int>[4413, 4463, 4513, 4563], <int>[4614, 4664, 4714, 4764], <int>[4814, 4864, 4914, 4965], <int>[5015, 5065, 5115, 5165], <int>[5215, 5265, 5316, 5366], <int>[5416, 5466, 5516, 5566], <int>[5616, 5667, 5717, 5767], <int>[5817, 5867, 5917, 5968], <int>[6018, 6068, 6118, 6168], <int>[6218, 6268, 6319, 6369], <int>[6419, 6469, 6519, 6569], <int>[6619, 6670, 6720, 6770], <int>[6820, 6870, 6920, 6970], <int>[7021, 7071, 7121, 7171], <int>[7221, 7271, 7321, 7372], <int>[7422, 7472, 7522, 7572], <int>[7622, 7673, 7723, 7773], <int>[7823, 7873, 7923, 7973], <int>[8024, 8074, 8124, 8174], <int>[8224, 8274, 8324, 8375], <int>[8425, 8475, 8525, 8575], <int>[8625, 8675, 8726, 8776], <int>[8826, 8876, 8926, 8976], <int>[9026, 9077, 9127, 9177], <int>[9227, 9277, 9327, 9378], <int>[9428, 9478, 9528, 9578], <int>[9628, 9678, 9729, 9779], <int>[9829, 9879, 9929, 9979], <int>[10029, 10080, 10130, 10180], <int>[10230, 10280, 10330, 10380], <int>[10431, 10481, 10531, 10581], <int>[10631, 10681, 10731, 10782], <int>[10832, 10882, 10932, 10982], <int>[11032, 11083, 11133, 11183], <int>[11233, 11283, 11333, 11383], <int>[11434, 11484, 11534, 11584], <int>[11634, 11684, 11734, 11785], <int>[11835, 11885, 11935, 11985], <int>[12035, 12085, 12136, 12186], <int>[12236, 12286, 12336, 12386], <int>[12436, 12487, 12537, 12587], <int>[12637, 12687, 12737, 12788], <int>[12838, 12888, 12938, 12988], <int>[13038, 13088, 13139, 13189]];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Tests of AudioSettingsModel.getPossibleFrequenciesForChunk()', () {
    test('Should [return possible frequencies] for chunk for [chunksCount == 1]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 451, 501, 552];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 2]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(1);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[602, 652, 702, 752];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 4]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(3);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[1003, 1053, 1103, 1153];

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 8]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(7);

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[1805, 1855, 1906, 1956];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 16]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(15);
      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[3410, 3460, 3510, 3560];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 32]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 32);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(31);

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[6619, 6670, 6720, 6770];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should [return possible frequencies] for chunk for [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(63);

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[13038, 13088, 13139, 13189];
      // @formatter:on

      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.assignDynamicGap()', () {
    test('Should [return dynamic frequencies] for [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);
      // @formatter:off
      List<int> actualAllPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750, 3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150, 4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750, 4800, 4850, 4900, 4950, 5000, 5050, 5100, 5150, 5200, 5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600, 5650, 5700, 5750, 5800, 5850, 5900, 5950, 6000, 6050, 6100, 6150, 6200, 6250, 6300, 6350, 6400, 6450, 6500, 6550, 6600, 6650, 6700, 6750, 6800, 6850, 6900, 6950, 7000, 7050, 7100, 7150, 7200, 7250, 7300, 7350, 7400, 7450, 7500, 7550, 7600, 7650, 7700, 7750, 7800, 7850, 7900, 7950, 8000, 8050, 8100, 8150, 8200, 8250, 8300, 8350, 8400, 8450, 8500, 8550, 8600, 8650, 8700, 8750, 8800, 8850, 8900, 8950, 9000, 9050, 9100, 9150, 9200, 9250, 9300, 9350, 9400, 9450, 9500, 9550, 9600, 9650, 9700, 9750, 9800, 9850, 9900, 9950, 10000, 10050, 10100, 10150, 10200, 10250, 10300, 10350, 10400, 10450, 10500, 10550, 10600, 10650, 10700, 10750, 10800, 10850, 10900, 10950, 11000, 11050, 11100, 11150, 11200, 11250, 11300, 11350, 11400, 11450, 11500, 11550, 11600, 11650, 11700, 11750, 11800, 11850, 11900, 11950, 12000, 12050, 12100, 12150, 12200, 12250, 12300, 12350, 12400, 12450, 12500, 12550, 12600, 12650, 12700, 12750, 12800, 12850, 12900, 12950, 13000, 13050, 13100, 13150];
      // @formatter:on

      // Act
      List<int> actualAllDynamicFrequencies = actualAudioSettingsModel.assignDynamicGap(actualAllPossibleFrequencies);

      // Assert
      // @formatter:off
      List<int> expectedAllDynamicFrequencies = <int>[400, 451, 501, 552, 602, 652, 702, 752, 802, 853, 903, 953, 1003, 1053, 1103, 1153, 1204, 1254, 1304, 1354, 1404, 1454, 1504, 1555, 1605, 1655, 1705, 1755, 1805, 1855, 1906, 1956, 2006, 2056, 2106, 2156, 2206, 2257, 2307, 2357, 2407, 2457, 2507, 2558, 2608, 2658, 2708, 2758, 2808, 2858, 2909, 2959, 3009, 3059, 3109, 3159, 3209, 3260, 3310, 3360, 3410, 3460, 3510, 3560, 3611, 3661, 3711, 3761, 3811, 3861, 3911, 3962, 4012, 4062, 4112, 4162, 4212, 4263, 4313, 4363, 4413, 4463, 4513, 4563, 4614, 4664, 4714, 4764, 4814, 4864, 4914, 4965, 5015, 5065, 5115, 5165, 5215, 5265, 5316, 5366, 5416, 5466, 5516, 5566, 5616, 5667, 5717, 5767, 5817, 5867, 5917, 5968, 6018, 6068, 6118, 6168, 6218, 6268, 6319, 6369, 6419, 6469, 6519, 6569, 6619, 6670, 6720, 6770, 6820, 6870, 6920, 6970, 7021, 7071, 7121, 7171, 7221, 7271, 7321, 7372, 7422, 7472, 7522, 7572, 7622, 7673, 7723, 7773, 7823, 7873, 7923, 7973, 8024, 8074, 8124, 8174, 8224, 8274, 8324, 8375, 8425, 8475, 8525, 8575, 8625, 8675, 8726, 8776, 8826, 8876, 8926, 8976, 9026, 9077, 9127, 9177, 9227, 9277, 9327, 9378, 9428, 9478, 9528, 9578, 9628, 9678, 9729, 9779, 9829, 9879, 9929, 9979, 10029, 10080, 10130, 10180, 10230, 10280, 10330, 10380, 10431, 10481, 10531, 10581, 10631, 10681, 10731, 10782, 10832, 10882, 10932, 10982, 11032, 11083, 11133, 11183, 11233, 11283, 11333, 11383, 11434, 11484, 11534, 11584, 11634, 11684, 11734, 11785, 11835, 11885, 11935, 11985, 12035, 12085, 12136, 12186, 12236, 12286, 12336, 12386, 12436, 12487, 12537, 12587, 12637, 12687, 12737, 12788, 12838, 12888, 12938, 12988, 13038, 13088, 13139, 13189];
      // @formatter:on

      expect(actualAllDynamicFrequencies, expectedAllDynamicFrequencies);
    });
  });

  group('Test of AudioSettingsModel.removeDynamicGap()', () {
    test('Should [return frequencies] with removed dynamic values for [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);
      // @formatter:off
      List<int> actualAllDynamicFrequencies = <int>[400, 451, 501, 552, 602, 652, 702, 752, 802, 853, 903, 953, 1003, 1053, 1103, 1153, 1204, 1254, 1304, 1354, 1404, 1454, 1504, 1555, 1605, 1655, 1705, 1755, 1805, 1855, 1906, 1956, 2006, 2056, 2106, 2156, 2206, 2257, 2307, 2357, 2407, 2457, 2507, 2558, 2608, 2658, 2708, 2758, 2808, 2858, 2909, 2959, 3009, 3059, 3109, 3159, 3209, 3260, 3310, 3360, 3410, 3460, 3510, 3560, 3611, 3661, 3711, 3761, 3811, 3861, 3911, 3962, 4012, 4062, 4112, 4162, 4212, 4263, 4313, 4363, 4413, 4463, 4513, 4563, 4614, 4664, 4714, 4764, 4814, 4864, 4914, 4965, 5015, 5065, 5115, 5165, 5215, 5265, 5316, 5366, 5416, 5466, 5516, 5566, 5616, 5667, 5717, 5767, 5817, 5867, 5917, 5968, 6018, 6068, 6118, 6168, 6218, 6268, 6319, 6369, 6419, 6469, 6519, 6569, 6619, 6670, 6720, 6770, 6820, 6870, 6920, 6970, 7021, 7071, 7121, 7171, 7221, 7271, 7321, 7372, 7422, 7472, 7522, 7572, 7622, 7673, 7723, 7773, 7823, 7873, 7923, 7973, 8024, 8074, 8124, 8174, 8224, 8274, 8324, 8375, 8425, 8475, 8525, 8575, 8625, 8675, 8726, 8776, 8826, 8876, 8926, 8976, 9026, 9077, 9127, 9177, 9227, 9277, 9327, 9378, 9428, 9478, 9528, 9578, 9628, 9678, 9729, 9779, 9829, 9879, 9929, 9979, 10029, 10080, 10130, 10180, 10230, 10280, 10330, 10380, 10431, 10481, 10531, 10581, 10631, 10681, 10731, 10782, 10832, 10882, 10932, 10982, 11032, 11083, 11133, 11183, 11233, 11283, 11333, 11383, 11434, 11484, 11534, 11584, 11634, 11684, 11734, 11785, 11835, 11885, 11935, 11985, 12035, 12085, 12136, 12186, 12236, 12286, 12336, 12386, 12436, 12487, 12537, 12587, 12637, 12687, 12737, 12788, 12838, 12888, 12938, 12988, 13038, 13088, 13139, 13189];

      // @formatter:on

      // Act
      // Since we want to test if all dynamic frequencies are decoded correctly and making single test is more efficient than making multiple for each
      // chunksCount we decided to use for loop to check all possibilities
      List<int> actualAllPossibleFrequencies = <int>[];
      for (int actualDynamicFrequency in actualAllDynamicFrequencies) {
        actualAllPossibleFrequencies.add(actualAudioSettingsModel.removeDynamicGap(actualDynamicFrequency));
      }

      // Assert
      // @formatter:off
      List<int> expectedAllPossibleFrequencies = <int>[400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, 2000, 2050, 2100, 2150, 2200, 2250, 2300, 2350, 2400, 2450, 2500, 2550, 2600, 2650, 2700, 2750, 2800, 2850, 2900, 2950, 3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350, 3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750, 3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150, 4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750, 4800, 4850, 4900, 4950, 5000, 5050, 5100, 5150, 5200, 5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600, 5650, 5700, 5750, 5800, 5850, 5900, 5950, 6000, 6050, 6100, 6150, 6200, 6250, 6300, 6350, 6400, 6450, 6500, 6550, 6600, 6650, 6700, 6750, 6800, 6850, 6900, 6950, 7000, 7050, 7100, 7150, 7200, 7250, 7300, 7350, 7400, 7450, 7500, 7550, 7600, 7650, 7700, 7750, 7800, 7850, 7900, 7950, 8000, 8050, 8100, 8150, 8200, 8250, 8300, 8350, 8400, 8450, 8500, 8550, 8600, 8650, 8700, 8750, 8800, 8850, 8900, 8950, 9000, 9050, 9100, 9150, 9200, 9250, 9300, 9350, 9400, 9450, 9500, 9550, 9600, 9650, 9700, 9750, 9800, 9850, 9900, 9950, 10000, 10050, 10100, 10150, 10200, 10250, 10300, 10350, 10400, 10450, 10500, 10550, 10600, 10650, 10700, 10750, 10800, 10850, 10900, 10950, 11000, 11050, 11100, 11150, 11200, 11250, 11300, 11350, 11400, 11450, 11500, 11550, 11600, 11650, 11700, 11750, 11800, 11850, 11900, 11950, 12000, 12050, 12100, 12150, 12200, 12250, 12300, 12350, 12400, 12450, 12500, 12550, 12600, 12650, 12700, 12750, 12800, 12850, 12900, 12950, 13000, 13050, 13100, 13150];
      // @formatter:on

      expect(actualAllPossibleFrequencies, expectedAllPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.parseBaseFrequencyToChunkFrequency', () {
    test('Should [return parsed frequencies] for all chunks with [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);
      List<int> actualBaseFrequencies = <int>[400, 600, 800, 1000];

      // Act
      // Since we don't want to make multiple tests for each chunksCount we decided to use for loop to check all possibilities
      List<int> actualChunkFrequencies = <int>[];
      for (int chunkIndex = 0; chunkIndex < 64; chunkIndex++) {
        for (int actualBaseFrequency in actualBaseFrequencies) {
          actualChunkFrequencies.add(actualAudioSettingsModel.parseBaseFrequencyToChunkFrequency(actualBaseFrequency, chunkIndex));
        }
      }

      // Assert
      // @formatter:off
      List<int> expectedChunkFrequencies = <int>[400, 600, 800, 1000, 600, 800, 1000, 1200, 800, 1000, 1200, 1400, 1000, 1200, 1400, 1600, 1200, 1400, 1600, 1800, 1400, 1600, 1800, 2000, 1600, 1800, 2000, 2200, 1800, 2000, 2200, 2400, 2000, 2200, 2400, 2600, 2200, 2400, 2600, 2800, 2400, 2600, 2800, 3000, 2600, 2800, 3000, 3200, 2800, 3000, 3200, 3400, 3000, 3200, 3400, 3600, 3200, 3400, 3600, 3800, 3400, 3600, 3800, 4000, 3600, 3800, 4000, 4200, 3800, 4000, 4200, 4400, 4000, 4200, 4400, 4600, 4200, 4400, 4600, 4800, 4400, 4600, 4800, 5000, 4600, 4800, 5000, 5200, 4800, 5000, 5200, 5400, 5000, 5200, 5400, 5600, 5200, 5400, 5600, 5800, 5400, 5600, 5800, 6000, 5600, 5800, 6000, 6200, 5800, 6000, 6200, 6400, 6000, 6200, 6400, 6600, 6200, 6400, 6600, 6800, 6400, 6600, 6800, 7000, 6600, 6800, 7000, 7200, 6800, 7000, 7200, 7400, 7000, 7200, 7400, 7600, 7200, 7400, 7600, 7800, 7400, 7600, 7800, 8000, 7600, 7800, 8000, 8200, 7800, 8000, 8200, 8400, 8000, 8200, 8400, 8600, 8200, 8400, 8600, 8800, 8400, 8600, 8800, 9000, 8600, 8800, 9000, 9200, 8800, 9000, 9200, 9400, 9000, 9200, 9400, 9600, 9200, 9400, 9600, 9800, 9400, 9600, 9800, 10000, 9600, 9800, 10000, 10200, 9800, 10000, 10200, 10400, 10000, 10200, 10400, 10600, 10200, 10400, 10600, 10800, 10400, 10600, 10800, 11000, 10600, 10800, 11000, 11200, 10800, 11000, 11200, 11400, 11000, 11200, 11400, 11600, 11200, 11400, 11600, 11800, 11400, 11600, 11800, 12000, 11600, 11800, 12000, 12200, 11800, 12000, 12200, 12400, 12000, 12200, 12400, 12600, 12200, 12400, 12600, 12800, 12400, 12600, 12800, 13000, 12600, 12800, 13000, 13200, 12800, 13000, 13200, 13400, 13000, 13200, 13400, 13600];
      // @formatter:on

      expect(actualChunkFrequencies, expectedChunkFrequencies);
    });
  });

  group('Test of AudioSettingsModel.parseChunkFrequencyToFrequency', () {
    test('Should [return parsed chunks] to frequencies with [chunksCount == 64]', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 64);
      // @formatter:off
      List<int> actualChunkFrequencies = <int>[400, 600, 800, 1000, 600, 800, 1000, 1200, 800, 1000, 1200, 1400, 1000, 1200, 1400, 1600, 1200, 1400, 1600, 1800, 1400, 1600, 1800, 2000, 1600, 1800, 2000, 2200, 1800, 2000, 2200, 2400, 2000, 2200, 2400, 2600, 2200, 2400, 2600, 2800, 2400, 2600, 2800, 3000, 2600, 2800, 3000, 3200, 2800, 3000, 3200, 3400, 3000, 3200, 3400, 3600, 3200, 3400, 3600, 3800, 3400, 3600, 3800, 4000, 3600, 3800, 4000, 4200, 3800, 4000, 4200, 4400, 4000, 4200, 4400, 4600, 4200, 4400, 4600, 4800, 4400, 4600, 4800, 5000, 4600, 4800, 5000, 5200, 4800, 5000, 5200, 5400, 5000, 5200, 5400, 5600, 5200, 5400, 5600, 5800, 5400, 5600, 5800, 6000, 5600, 5800, 6000, 6200, 5800, 6000, 6200, 6400, 6000, 6200, 6400, 6600, 6200, 6400, 6600, 6800, 6400, 6600, 6800, 7000, 6600, 6800, 7000, 7200, 6800, 7000, 7200, 7400, 7000, 7200, 7400, 7600, 7200, 7400, 7600, 7800, 7400, 7600, 7800, 8000, 7600, 7800, 8000, 8200, 7800, 8000, 8200, 8400, 8000, 8200, 8400, 8600, 8200, 8400, 8600, 8800, 8400, 8600, 8800, 9000, 8600, 8800, 9000, 9200, 8800, 9000, 9200, 9400, 9000, 9200, 9400, 9600, 9200, 9400, 9600, 9800, 9400, 9600, 9800, 10000, 9600, 9800, 10000, 10200, 9800, 10000, 10200, 10400, 10000, 10200, 10400, 10600, 10200, 10400, 10600, 10800, 10400, 10600, 10800, 11000, 10600, 10800, 11000, 11200, 10800, 11000, 11200, 11400, 11000, 11200, 11400, 11600, 11200, 11400, 11600, 11800, 11400, 11600, 11800, 12000, 11600, 11800, 12000, 12200, 11800, 12000, 12200, 12400, 12000, 12200, 12400, 12600, 12200, 12400, 12600, 12800, 12400, 12600, 12800, 13000, 12600, 12800, 13000, 13200, 12800, 13000, 13200, 13400, 13000, 13200, 13400, 13600];
      // @formatter:on

      // Act
      // Since we want to check all possibilities for parseChunkFrequencyToFrequency but we don't want to make multiple test we decided to use for loop
      List<int> actualBaseFrequencies = <int>[];
      for (int i = 0; i < actualChunkFrequencies.length; i++) {
        actualBaseFrequencies.add(actualAudioSettingsModel.parseChunkFrequencyToFrequency(actualChunkFrequencies[i], i ~/ 4));
      }

      // Assert
      // @formatter:off
      List<int> expectedChunkFrequencies = <int>[400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000, 400, 600, 800, 1000];
      // @formatter:on

      expect(actualBaseFrequencies, expectedChunkFrequencies);
    });
  });
}
