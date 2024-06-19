import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';

void main() {
  group('Test of AudioSettingsModel.maxFrequency', () {
    test('Should return max frequency value (600) for bitsPerFrequency (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 600;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (1000) for bitsPerFrequency (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 1000;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (3400) for bitsPerFrequency (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 3400;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });

    test('Should return max frequency value (51400) for bitsPerFrequency (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      int actualMaxFrequency = actualAudioSettingsModel.maxBaseFrequency;

      // Assert
      int expectedMaxFrequency = 51400;
      expect(actualMaxFrequency, expectedMaxFrequency);
    });
  });

  group('Test of AudioSettingsModel.getPossibleFrequenciesWithAdjustedGap()', () {
    test('Should return list of possible frequencies from chunk for chunksCount (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies from chunk for chunksCount (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies from chunk for chunksCount (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies from chunk for chunksCount (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies from chunk for chunksCount (16)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesForChunk(0);
      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.possibleBaseFrequencies', () {
    test('Should return list of possible frequencies for bitsPerFrequency (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies for bitsPerFrequency (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(bitsPerFrequency: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.possibleBaseFrequencies;

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000, 5200, 5400, 5600, 5800, 6000, 6200, 6400, 6600, 6800, 7000, 7200, 7400, 7600, 7800, 8000, 8200, 8400, 8600, 8800, 9000, 9200, 9400, 9600, 9800, 10000, 10200, 10400, 10600, 10800, 11000, 11200, 11400, 11600, 11800, 12000, 12200, 12400, 12600, 12800, 13000, 13200, 13400, 13600, 13800, 14000, 14200, 14400, 14600, 14800, 15000, 15200, 15400, 15600, 15800, 16000, 16200, 16400, 16600, 16800, 17000, 17200, 17400, 17600, 17800, 18000, 18200, 18400, 18600, 18800, 19000, 19200, 19400, 19600, 19800, 20000, 20200, 20400, 20600, 20800, 21000, 21200, 21400, 21600, 21800, 22000, 22200, 22400, 22600, 22800, 23000, 23200, 23400, 23600, 23800, 24000, 24200, 24400, 24600, 24800, 25000, 25200, 25400, 25600, 25800, 26000, 26200, 26400, 26600, 26800, 27000, 27200, 27400, 27600, 27800, 28000, 28200, 28400, 28600, 28800, 29000, 29200, 29400, 29600, 29800, 30000, 30200, 30400, 30600, 30800, 31000, 31200, 31400, 31600, 31800, 32000, 32200, 32400, 32600, 32800, 33000, 33200, 33400, 33600, 33800, 34000, 34200, 34400, 34600, 34800, 35000, 35200, 35400, 35600, 35800, 36000, 36200, 36400, 36600, 36800, 37000, 37200, 37400, 37600, 37800, 38000, 38200, 38400, 38600, 38800, 39000, 39200, 39400, 39600, 39800, 40000, 40200, 40400, 40600, 40800, 41000, 41200, 41400, 41600, 41800, 42000, 42200, 42400, 42600, 42800, 43000, 43200, 43400, 43600, 43800, 44000, 44200, 44400, 44600, 44800, 45000, 45200, 45400, 45600, 45800, 46000, 46200, 46400, 46600, 46800, 47000, 47200, 47400, 47600, 47800, 48000, 48200, 48400, 48600, 48800, 49000, 49200, 49400, 49600, 49800, 50000, 50200, 50400, 50600, 50800, 51000, 51200, 51400];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.getPossibleFrequenciesWithAdjustedGap()', () {
    test('Should return list of possible frequencies with adjusted gap for chunksCount (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesWithAdjustedGap();

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies with adjusted gap for chunksCount (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesWithAdjustedGap();

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies with adjusted gap for chunksCount (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesWithAdjustedGap();

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805, 2006, 2206, 2407, 2608, 2808, 3009, 3209, 3410];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies with adjusted gap for chunksCount (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesWithAdjustedGap();

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805, 2006, 2206, 2407, 2608, 2808, 3009, 3209, 3410, 3611, 3811, 4012, 4212, 4413, 4614, 4814, 5015, 5215, 5416, 5616, 5817, 6018, 6218, 6419, 6619];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of possible frequencies with adjusted gap for chunksCount (16)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.getPossibleFrequenciesWithAdjustedGap();
      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805, 2006, 2206, 2407, 2608, 2808, 3009, 3209, 3410, 3611, 3811, 4012, 4212, 4413, 4614, 4814, 5015, 5215, 5416, 5616, 5817, 6018, 6218, 6419, 6619, 6820, 7021, 7221, 7422, 7622, 7823, 8024, 8224, 8425, 8625, 8826, 9026, 9227, 9428, 9628, 9829, 10029, 10230, 10431, 10631, 10832, 11032, 11233, 11434, 11634, 11835, 12035, 12236, 12436, 12637, 12838, 13038];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.dynamicGap()', () {
    test('Should return list of dynamic gaped frequencies for given chunksCount (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.dynamicGap(<int>[400, 600]);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of dynamic gaped frequencies for given chunksCount (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.dynamicGap(<int>[400, 600, 800, 1000]);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of dynamic gaped frequencies for given chunksCount (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.dynamicGap(<int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800]);

      // Assert
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805];
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of dynamic gaped frequencies for given chunksCount (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.dynamicGap(<int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200]);

      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805, 2006, 2206, 2407, 2608, 2808, 3009, 3209];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });

    test('Should return list of dynamic gaped frequencies for given chunksCount (16)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      List<int> actualPossibleFrequencies = actualAudioSettingsModel.dynamicGap(<int>[400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400 ,3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000, 5200, 5400, 5600 ,5800, 6000, 6200, 6400, 6600, 6800, 7000, 7200, 7400, 7600, 7800, 8000, 8200, 8400, 8600, 8800, 9000, 9200,9400,9600,9800,10000,10200,10400,10600,10800,11000,11200,11400,11600,11800,12000,12200,12400,12600,12800,13000]);
      // Assert
      // @formatter:off
      List<int> expectedPossibleFrequencies = <int>[400, 602, 802, 1003, 1204, 1404, 1605, 1805, 2006, 2206, 2407, 2608, 2808, 3009, 3209, 3410, 3611, 3811, 4012, 4212, 4413, 4614, 4814, 5015, 5215, 5416, 5616, 5817, 6018, 6218, 6419, 6619, 6820, 7021, 7221, 7422, 7622, 7823, 8024, 8224, 8425, 8625, 8826, 9026, 9227, 9428, 9628, 9829, 10029, 10230, 10431, 10631, 10832, 11032, 11233, 11434, 11634, 11835, 12035, 12236, 12436, 12637, 12838, 13038];
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequencies);
    });
  });

  group('Test of AudioSettingsModel.unDynamicGap()', () {
    test('Should return un dynamized frequency for given frequency and chunksCount (1)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 1);

      // Act
      int actualPossibleFrequencies = actualAudioSettingsModel.unDynamicGap(400);

      // Assert
      int expectedPossibleFrequency = 400;
      expect(actualPossibleFrequencies, expectedPossibleFrequency);
    });

    test('Should return un dynamized frequency for given frequency and chunksCount (2)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 2);

      // Act
      int actualPossibleFrequencies = actualAudioSettingsModel.unDynamicGap(602);

      // Assert
      int expectedPossibleFrequency = 600;
      expect(actualPossibleFrequencies, expectedPossibleFrequency);
    });

    test('Should return un dynamized frequency for given frequency and chunksCount (4)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 4);

      // Act
      int actualPossibleFrequencies = actualAudioSettingsModel.unDynamicGap(802);

      // Assert
      int expectedPossibleFrequency = 800;
      expect(actualPossibleFrequencies, expectedPossibleFrequency);
    });

    test('Should return un dynamized frequency for given frequency and chunksCount (8)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);

      // Act
      int actualPossibleFrequencies = actualAudioSettingsModel.unDynamicGap(1003);

      // Assert
      // @formatter:off
      int expectedPossibleFrequency = 1000;
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequency);
    });

    test('Should return un dynamized frequency for given frequency and chunksCount (16)', () {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16);

      // Act
      int actualPossibleFrequencies = actualAudioSettingsModel.unDynamicGap(1204);
      // Assert
      // @formatter:off
      int expectedPossibleFrequency = 1200;
      // @formatter:on
      expect(actualPossibleFrequencies, expectedPossibleFrequency);
    });
  });

  group('Test of AudioSettingsModel.parseFrequencyToChunkFrequency', () {
    group('Chunk 0', () {
      test('Frequency 400 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(400, 0);
        int expectedChunkFrequency = 400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 600 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(600, 0);
        int expectedChunkFrequency = 600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 800 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(800, 0);
        int expectedChunkFrequency = 800;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1000 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(1000, 0);
        int expectedChunkFrequency = 1000;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });

    group('Chunk 1', () {
      test('Frequency 400 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(400, 1);
        int expectedChunkFrequency = 1200;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 600 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(600, 1);
        int expectedChunkFrequency = 1400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 800 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(800, 1);
        int expectedChunkFrequency = 1600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1000 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(1000, 1);
        int expectedChunkFrequency = 1800;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });

    group('Chunk 3', () {
      test('Frequency 400 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(400, 2);
        int expectedChunkFrequency = 2000;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 600 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(600, 2);
        int expectedChunkFrequency = 2200;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 800 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(800, 2);
        int expectedChunkFrequency = 2400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1000 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseFrequencyToChunkFrequency(1000, 2);
        int expectedChunkFrequency = 2600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });
  });

  group('Test of AudioSettingsModel.parseChunkFrequencyToFrequency', () {
    group('Chunk 0', () {
      test('Frequency 400 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(400, 0);
        int expectedChunkFrequency = 400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 600 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(600, 0);
        int expectedChunkFrequency = 600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 800 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(800, 0);
        int expectedChunkFrequency = 800;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1000 Chunk 0', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(1000, 0);
        int expectedChunkFrequency = 1000;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });

    group('Chunk 1', () {
      test('Frequency 1200 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(1200, 1);
        int expectedChunkFrequency = 400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1400 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(1400, 1);
        int expectedChunkFrequency = 600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1600 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(1600, 1);
        int expectedChunkFrequency = 800;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 1800 Chunk 1', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(1800, 1);
        int expectedChunkFrequency = 1000;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });

    group('Chunk 3', () {
      test('Frequency 2000 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(2000, 2);
        int expectedChunkFrequency = 400;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 2200 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(2200, 2);
        int expectedChunkFrequency = 600;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 2400 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(2400, 2);
        int expectedChunkFrequency = 800;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });

      test('Frequency 2600 Chunk 2', () {
        AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults();

        int actualChunkFrequency = actualAudioSettingsModel.parseChunkFrequencyToFrequency(2600, 2);
        int expectedChunkFrequency = 1000;
        expect(actualChunkFrequency, expectedChunkFrequency);
      });
    });
  });
}
