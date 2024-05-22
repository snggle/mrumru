import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoUtils {
  static String calcChecksum({required String text, required int length}) {
    List<int> bytes = utf8.encode(text);
    Digest md5Digest = md5.convert(bytes);

    return md5Digest.bytes.map((int byte) => byte.toRadixString(2)).join().padRight(length, '0').substring(0, length);
  }
}
