import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  static Uint8List calcChecksum({required String text}) {
    List<int> bytes = utf8.encode(text);
    Digest md5Digest = md5.convert(bytes);
    return Uint8List.fromList(md5Digest.bytes);
  }

  static Uint8List getBytes({required int length, required int max}) {
    Random randomNumberGenerator = Random.secure();
    Uint8List bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      // IMPORTANT NOTE: nextInt() returns a value from 0 to X - 1
      // Be careful to avoid non-uniform distribution of random numbers
      bytes[i] = randomNumberGenerator.nextInt(max + 1).toInt();
    }
    return bytes;
  }
}
