import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';

void main() {
  group('Test of DataFrame.toBytes()', () {
    test('Should [return correct bytes] representation', () {
      // Arrange
      FrameReminder<DataFrame> actualDataFrame = DataFrame.fromBytes(Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]));

      // Act
      Uint8List actualBytes = actualDataFrame.value.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of DataFrame.fromValues()', () {
    test('Should [return DataFrame] correctly from given values', () {
      // Arrange
      int actualFrameIndex = 1;
      Uint8List actualData = Uint8List.fromList(<int>[1, 2, 3, 4]);

      // Act
      DataFrame actualDataFrame = DataFrame.fromValues(
        frameIndex: actualFrameIndex,
        data: actualData,
      );

      // Assert
      FrameReminder<DataFrame> expectedDataFrame = DataFrame.fromBytes(Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
      ]));

      expect(actualDataFrame, expectedDataFrame.value);
    });
  });

  group('Test of DataFrame.fromBytes()', () {
    test('Should [return DataFrame] correctly from given bytes', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]);

      // Act
      FrameReminder<DataFrame> actualDataFrame = DataFrame.fromBytes(actualBytes);

      // Assert
      FrameReminder<DataFrame> expectedDataFrame = DataFrame.fromBytes(Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        0, 0, // frameChecksum
      ]));

      expect(actualDataFrame.value, expectedDataFrame.value);
    });
  });
}
