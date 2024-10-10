import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class UintDynamic with EquatableMixin {
  final int bitsSize;
  final Uint8List _bytes;

  UintDynamic(this._bytes, this.bitsSize);

  static UintReminder<UintDynamic> fromBytes(Uint8List bytes, int bitsSize) {
    int bytesSize = bitsSize ~/ 8;
    Uint8List value = bytes.sublist(0, bytesSize);
    Uint8List reminder = bytes.sublist(bytesSize);

    return UintReminder<UintDynamic>(UintDynamic(value, bitsSize), reminder);
  }

  Uint8List get bytes {
    int bytesSize = bitsSize ~/ 8;
    Uint8List result = Uint8List(bytesSize)..setAll(0, _bytes);
    return result;
  }

  int toInt() {
    return BigIntUtils.decode(bytes).toInt();
  }

  @override
  List<Object?> get props => <Object?>[_bytes, bitsSize];
}
