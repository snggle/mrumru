import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class FrameProcessor {
  Uint8List computeFrameChecksum(String text) {
    List<int> bytes = utf8.encode(text);
    Digest md5Digest = md5.convert(bytes);
    return Uint8List.fromList(md5Digest.bytes);
  }
  Uint8List computeCompositeChecksum(List<Uint8List> frameChecksums) {
    List<int> concatenatedBytes = frameChecksums.expand((Uint8List bytes) => bytes).toList();
    Digest md5Digest = md5.convert(concatenatedBytes);
    return Uint8List.fromList(md5Digest.bytes);
  }
}
