import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

void main() {
  late FrameSettingsModel actualFrameSettings;

  setUp(() => actualFrameSettings = FrameSettingsModel.withDefaults());

  group('Tests of CryptoUtils.calcChecksum()', () {
    test('Should return [checksum] for given string', () {
      // Arrange
      String actualRawData = '123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~';

      // Act
      String actualChecksum = CryptoUtils.calcChecksum(text: actualRawData, length: actualFrameSettings.checksumBitsLength);

      // Assert
      String expectedChecksum = '11010000';
      expect(actualChecksum, expectedChecksum);
    });
  });
}
