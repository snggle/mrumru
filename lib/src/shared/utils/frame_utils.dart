import 'dart:typed_data';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameProcessor {
  /// Computes the checksum for a frame using CryptoUtils.
  static Uint8List computeFrameChecksum(Uint8List data) {
    return CryptoUtils.calcChecksum(text: String.fromCharCodes(data));
  }

  /// Computes the composite checksum over all frame checksums using CryptoUtils.
  static Uint8List computeCompositeChecksum(List<Uint8List> checksums) {
    List<int> concatenated = checksums.expand((Uint8List bytes) => bytes).toList();
    String concatenatedString = String.fromCharCodes(concatenated);
    return CryptoUtils.calcChecksum(text: concatenatedString);
  }
}
