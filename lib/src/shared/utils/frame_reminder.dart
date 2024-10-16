import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

/// A class that represents a decoded [ABaseFrame] with a reminder.
class FrameReminder<T extends ABaseFrame> extends Equatable {
  /// The decoded [ABaseFrame] value.
  final T value;

  /// The remaining unprocessed bytes after decoding the frame.
  final Uint8List reminder;

  /// The number of bits consumed during the decoding of [value].
  ///
  /// This getter calculates the number of bits used by the frame's binary
  /// representation.
  int get bitsConsumed => value.toBytes().length * BinaryUtils.bitsInByte;

  /// Creates an instance of [FrameReminder] with the given [value] and [reminder].
  ///
  /// The [value] represents the decoded frame, and [reminder] contains any
  /// leftover bytes not yet processed.
  const FrameReminder({
    required this.value,
    required this.reminder,
  });

  /// Overrides equality comparison to include the [value] and [reminder].
  @override
  List<Object?> get props => <Object?>[value, reminder];
}
