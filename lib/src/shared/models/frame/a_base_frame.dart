import 'dart:typed_data';

import 'package:mrumru/src/shared/models/frame/frame_settings_model.dart';

abstract class ABaseFrame {
  int get frameIndexInt;

  int get frameLengthInt;

  String get binaryString;

  Uint8List toBytes(FrameSettingsModel frameSettingsModel);
}
