import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// A class that contains utilities for cryptographic operations.
class CryptoUtils {
  /// Calculates the checksum of the given [bytes].
  static Uint8List calcChecksumFromBytes({required Uint8List bytes}) {
    Digest md5Digest = md5.convert(bytes);
    return Uint8List.fromList(md5Digest.bytes);
  }
}
