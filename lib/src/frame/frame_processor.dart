import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class FrameProcessor {
  static Uint8List computeFrameChecksum(Uint8List frameBytesWithoutChecksum) {
    return Uint8List.fromList(md5.convert(frameBytesWithoutChecksum).bytes);
  }

  static Uint8List computeCompositeChecksum(List<Uint8List> frameChecksums) {
    List<int> concatenatedChecksums = frameChecksums.expand((Uint8List e) => e).toList();
    return Uint8List.fromList(md5.convert(concatenatedChecksums).bytes);
  }

  static String getBinaryString(Uint8List frameBytes) {
    return frameBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }
}
