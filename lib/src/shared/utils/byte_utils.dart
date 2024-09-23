import 'dart:convert';
import 'dart:typed_data';

class ByteUtils {
  static Uint8List intToBytes(int value, int byteLength) {
    final Uint8List result = Uint8List(byteLength);
    for (int i = 0; i < byteLength; i++) {
      result[byteLength - i - 1] = (value >> (8 * i)) & 0xFF;
    }
    return result;
  }

  static int bytesToInt(Uint8List bytes) {
    int value = 0;
    for (final int byte in bytes) {
      value = (value << 8) | byte;
    }
    return value;
  }

  static Uint8List stringToBytes(String value, [int? expectedLength]) {
    final Uint8List bytes = Uint8List.fromList(utf8.encode(value));
    if (expectedLength != null && bytes.length != expectedLength) {
      throw ArgumentError('String length does not match expected length');
    }
    return bytes;
  }

  static String bytesToString(Uint8List bytes) {
    return utf8.decode(bytes);
  }
}