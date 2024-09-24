import 'dart:typed_data';

abstract class ABaseFrame {
  int get frameIndex;

  int get frameLength;

  Uint8List toBytes();
}
