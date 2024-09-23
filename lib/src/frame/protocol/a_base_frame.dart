import 'dart:typed_data';

abstract class ABaseFrame {
  final int frameIndex;
  final int frameLength;

  ABaseFrame({
    required this.frameIndex,
    required this.frameLength,
  });

  Uint8List toBytes();
  String get binaryString;
  String get dataString;
}
