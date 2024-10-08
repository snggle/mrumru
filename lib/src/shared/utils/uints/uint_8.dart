import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class Uint8 extends UintDynamic {
  static const int _bytesSize = 1;
  static const int _bitsSize = 8;

  Uint8(Uint8List bytes) : super(bytes, _bitsSize);

  factory Uint8.fromInt(int value) {
    return Uint8(BigIntUtils.encode(BigInt.from(value), _bytesSize));
  }

  static UintReminder<Uint8> fromBytes(Uint8List bytes) {
    Uint8List value = bytes.sublist(0, _bytesSize);
    Uint8List reminder = bytes.sublist(_bytesSize);

    return UintReminder<Uint8>(Uint8(value), reminder);
  }
}
