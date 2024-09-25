import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class FrameProcessor {
  Uint8List computeCompositeChecksumUint8List(List<Uint8List> frameChecksumsUint8List) {
    final List<int> concatenatedChecksumsIntList = frameChecksumsUint8List.expand((Uint8List e) => e).toList();
    return Uint8List.fromList(md5.convert(concatenatedChecksumsIntList).bytes);
  }

  String computeFrameChecksumString(Uint8List frameBytesWithoutChecksumUint8List) {
    return md5.convert(frameBytesWithoutChecksumUint8List).toString();
  }

  String getBinaryString(Uint8List frameBytesUint8List) {
    return frameBytesUint8List.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }
}
