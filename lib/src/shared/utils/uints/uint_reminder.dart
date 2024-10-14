import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

/// A class that represents a [UintDynamic] with a reminder.
class UintReminder<T extends UintDynamic> extends Equatable {
  /// The value of the [UintDynamic].
  final T value;
  final Uint8List reminder;

  /// Creates a instance of [UintReminder] with the given [value] and [reminder].
  const UintReminder(this.value, this.reminder);

  @override
  List<Object?> get props => <Object?>[value, reminder];
}
