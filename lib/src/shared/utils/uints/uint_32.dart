import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class Uint32 extends UintDynamic {
  static const int _bytesSize = 4;
  static const int _bitsSize = 32;

  Uint32(Uint8List bytes) : super(bytes, _bitsSize);

  static UintReminder<Uint32> fromBytes(Uint8List bytes) {
    Uint8List value = bytes.sublist(0, _bytesSize);
    Uint8List reminder = bytes.sublist(_bytesSize);

    return UintReminder<Uint32>(Uint32(value), reminder);
  }
}
