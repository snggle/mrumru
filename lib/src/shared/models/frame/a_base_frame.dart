import 'dart:typed_data';

abstract class AFrameBase {
  final int frameIndex;
  final int frameLength;
  final Uint8List frameChecksum;

  AFrameBase({
    required this.frameIndex,
    required this.frameLength,
    required this.frameChecksum,
  });

  // Abstract method to convert to bytes
  List<int> toBytes();
}
