import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

class UintReminder<T extends UintDynamic> {
  final T value;
  final Uint8List reminder;

  UintReminder(this.value, this.reminder);
}
