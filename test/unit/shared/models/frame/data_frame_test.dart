import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/dtos/data_frame.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of DataFrame.toBytes()', () {
    test('Should [return bytes] representation', () {
      // Arrange
      DataFrame actualDataFrame = DataFrame.fromValues(frameIndex: 1, data: Uint8List.fromList(<int>[1, 2, 3, 4]));

      // Act
      Uint8List actualBytes = actualDataFrame.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of DataFrame.fromValues()', () {
    test('Should [return DataFrame] correctly from given values', () {
      // Act
      DataFrame actualDataFrame = DataFrame.fromValues(
        frameIndex: 1,
        data: Uint8List.fromList(<int>[1, 2, 3, 4]),
      );

      // Assert
      DataFrame expectedDataFrame = DataFrame(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 4])),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16(Uint8List.fromList(<int>[70, 39])),
      );

      expect(actualDataFrame, expectedDataFrame);
    });
  });

  group('Test of DataFrame.fromBytes()', () {
    test('Should [return FrameReminder] containing DataFrame from given bytes when [reminder EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
      ]);

      // Act
      FrameReminder<DataFrame> actualDataFrame = DataFrame.fromBytes(actualBytes);

      // Assert
      FrameReminder<DataFrame> expectedDataFrame = FrameReminder<DataFrame>(
        value: DataFrame.fromValues(
          frameIndex: 1,
          data: Uint8List.fromList(<int>[1, 2, 3, 4]),
        ),
        reminder: Uint8List.fromList(<int>[]),
      );

      expect(actualDataFrame, expectedDataFrame);
    });

    test('Should [return FrameReminder] containing DataFrame from given bytes when [reminder NOT EMPTY]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
        0, 25, // reminder
      ]);

      // Act
      FrameReminder<DataFrame> actualDataFrame = DataFrame.fromBytes(actualBytes);

      // Assert
      FrameReminder<DataFrame> expectedDataFrame = FrameReminder<DataFrame>(
        value: DataFrame.fromValues(
          frameIndex: 1,
          data: Uint8List.fromList(<int>[1, 2, 3, 4]),
        ),
        reminder: Uint8List.fromList(<int>[0, 25]),
      );

      expect(actualDataFrame, expectedDataFrame);
    });
  });
}
