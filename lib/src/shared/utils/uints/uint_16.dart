import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class Uint16 extends UintDynamic {
  static const int _bytesSize = 2;
  static const int _bitsSize = 16;

  Uint16(Uint8List bytes) : super(bytes, _bitsSize);

  factory Uint16.fromInt(int value) {
    return Uint16(BigIntUtils.encode(BigInt.from(value), _bytesSize));
  }

  static UintReminder<Uint16> fromBytes(Uint8List bytes) {
    Uint8List value = bytes.sublist(0, _bytesSize);
    Uint8List reminder = bytes.sublist(_bytesSize);

    return UintReminder<Uint16>(Uint16(value), reminder);
  }
}
