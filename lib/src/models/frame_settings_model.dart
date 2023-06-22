import 'package:equatable/equatable.dart';

class FrameSettingsModel with EquatableMixin {
  final int frameIndexBitsLength;
  final int framesCountBitsLength;
  final int dataBitsLength;
  final int checksumBitsLength;

  final int frameSize;
  final int asciiCharacterCountInFrame;

  FrameSettingsModel({
    required this.frameIndexBitsLength,
    required this.framesCountBitsLength,
    required this.dataBitsLength,
    required this.checksumBitsLength,
    required this.frameSize,
    required this.asciiCharacterCountInFrame,
  });

  factory FrameSettingsModel.withDefaults() {
    int frameIndexBitsLength = 8;
    int framesCountBitsLength = 8;
    int dataBitsLength = 32;
    int checksumBitsLength = 8;

    return FrameSettingsModel(
      frameIndexBitsLength: frameIndexBitsLength,
      framesCountBitsLength: framesCountBitsLength,
      dataBitsLength: dataBitsLength,
      checksumBitsLength: checksumBitsLength,
      frameSize: frameIndexBitsLength + framesCountBitsLength + dataBitsLength + checksumBitsLength,
      asciiCharacterCountInFrame: dataBitsLength ~/ 8,
    );
  }

  @override
  List<Object?> get props => <Object>[frameIndexBitsLength, framesCountBitsLength, dataBitsLength, checksumBitsLength, frameSize, asciiCharacterCountInFrame];
}
