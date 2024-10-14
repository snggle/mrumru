import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/big_int_utils.dart';

/// A class that contains utilities for binary operations.
class BinaryUtils {
  /// Converts a binary string to a list of bytes.
  static Uint8List convertBinaryToBytes(String binaryText) {
    Uint8List byteList = Uint8List((binaryText.length / BigIntUtils.bitsInByte).ceil());
    for (int i = 0; i < binaryText.length; i += BigIntUtils.bitsInByte) {
      String byteString = binaryText.substring(i, i + BigIntUtils.bitsInByte);
      int byte = int.parse(byteString, radix: 2);
      byteList[i ~/ BigIntUtils.bitsInByte] = byte;
    }
    return byteList;
  }
}
