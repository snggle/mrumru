// frame_processor.dart

import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class FrameProcessor {
  /// Computes the checksum for a frame using MD5.
  static Uint8List computeFrameChecksum(Uint8List data) {
    final Digest digest = md5.convert(data);
    return Uint8List.fromList(digest.bytes);
  }

  /// Computes the composite checksum over all frame checksums.
  static Uint8List computeCompositeChecksum(List<Uint8List> checksums) {
    final List<int> concatenated = checksums.expand((Uint8List bytes) => bytes).toList();
    final Digest digest = md5.convert(concatenated);
    return Uint8List.fromList(digest.bytes);
  }
}
