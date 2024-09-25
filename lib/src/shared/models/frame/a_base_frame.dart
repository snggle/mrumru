import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';


abstract class ABaseFrame {
  int get frameIndexInt;

  int get frameLengthInt;

  Uint8List toBytes(FrameSettingsModel frameSettingsModel);

  String get binaryString;
}
