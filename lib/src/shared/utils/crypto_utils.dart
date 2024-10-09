import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  static Uint8List calcChecksumFromString({required String text}) {
    List<int> bytes = utf8.encode(text);
    Digest md5Digest = md5.convert(bytes);
    return Uint8List.fromList(md5Digest.bytes);
  }

  static Uint8List calcChecksumFromBytes({required Uint8List bytes}) {
    Digest md5Digest = md5.convert(bytes);
    return Uint8List.fromList(md5Digest.bytes);
  }
}
