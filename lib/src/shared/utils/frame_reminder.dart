import 'dart:typed_data';

import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';

class FrameReminder<T extends AFrameBase> {
  final T value;
  final Uint8List reminder;

  FrameReminder({
    required this.value,
    required this.reminder,
  });
}