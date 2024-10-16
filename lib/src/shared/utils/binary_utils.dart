import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';

/// A class that provides utility methods for binary operations.
///
/// `BinaryUtils` offers methods for converting between binary strings and
/// byte arrays, as well as handling frame-specific binary conversions.
class BinaryUtils {
  /// The number of bits in a single byte.
  static const int bitsInByte = 8;

  /// Converts a binary string to a list of bytes.
  ///
  /// [binaryText] is a string representing binary data, which is divided
  /// into groups of 8 bits (1 byte) and converted into a `Uint8List`.
  static Uint8List convertBinaryToBytes(String binaryText) {
    Uint8List byteList = Uint8List((binaryText.length / bitsInByte).ceil());
    for (int i = 0; i < binaryText.length; i += bitsInByte) {
      String byteString = binaryText.substring(i, i + bitsInByte);
      int byte = int.parse(byteString, radix: 2);
      byteList[i ~/ bitsInByte] = byte;
    }
    return byteList;
  }

  /// Converts the bytes of a frame to a binary string.
  ///
  /// [frame] is an instance of `ABaseFrame`, and this method converts each
  /// byte of the frame into its binary string representation, padding it to 8 bits.
  static String frameToBinaryString(ABaseFrame frame) {
    return frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(BinaryUtils.bitsInByte, '0')).join();
  }
}
