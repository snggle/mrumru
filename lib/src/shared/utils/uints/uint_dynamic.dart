import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a UintDynamic.
class UintDynamic with EquatableMixin {
  /// The size of the UintDynamic in bits.
  final int bitsSize;
  final Uint8List _bytes;

  /// Creates a instance of [UintDynamic] with the given [bytes].
  UintDynamic(this._bytes, this.bitsSize);

  /// Creates a instance of [UintDynamic] from the given [int] value.
  static UintReminder<UintDynamic> fromBytes(Uint8List bytes, int bitsSize) {
    int bytesSize = bitsSize ~/ BigIntUtils.bitsInByte;
    if (bytes.length < bytesSize) {
      throw BytesTooShortException('Not enough bytes to create Uint8');
    }
    Uint8List value = bytes.sublist(0, bytesSize);
    Uint8List reminder = bytes.sublist(bytesSize);

    return UintReminder<UintDynamic>(UintDynamic(value, bitsSize), reminder);
  }

  /// Return the bytes of the [UintDynamic].
  Uint8List get bytes {
    int bytesSize = bitsSize ~/ BigIntUtils.bitsInByte;
    Uint8List result = Uint8List(bytesSize)..setAll(0, _bytes);
    return result;
  }

  /// Return the int value of the [UintDynamic].
  int toInt() {
    return BigIntUtils.decode(bytes).toInt();
  }

  @override
  List<Object?> get props => <Object?>[_bytes, bitsSize];
}
