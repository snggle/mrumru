import 'dart:typed_data';

import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';

/// A class that represents a [ABaseFrame] with a reminder.
class FrameReminder<T extends ABaseFrame> {
  /// The value of the [ABaseFrame].
  final T value;
  final Uint8List reminder;

  /// The number of bits consumed by the [value].
  int get bitsConsumed => value.toBytes().length * BigIntUtils.bitsInByte;

  /// Creates a instance of [FrameReminder] with the given [value] and [reminder].
  FrameReminder({
    required this.value,
    required this.reminder,
  });
}
