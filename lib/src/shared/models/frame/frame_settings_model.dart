import 'package:equatable/equatable.dart';

class FrameSettingsModel with EquatableMixin {
  final int frameIndexBitsLength;
  final int frameLengthBitsLength;
  final int framesCountBitsLength;
  final int protocolIdBitsLength;
  final int sessionIdBitsLength;
  final int compositeChecksumBitsLength;
  final int checksumBitsLength;
  final int dataBitsLength;

  final int frameSize;
  final int asciiCharacterCountInFrame;

  FrameSettingsModel({
    required this.frameIndexBitsLength,
    required this.frameLengthBitsLength,
    required this.framesCountBitsLength,
    required this.protocolIdBitsLength,
    required this.sessionIdBitsLength,
    required this.compositeChecksumBitsLength,
    required this.checksumBitsLength,
    required this.dataBitsLength,
    required this.frameSize,
    required this.asciiCharacterCountInFrame,
  });

  factory FrameSettingsModel.withDefaults() {
    int frameIndexBitsLength = 16;
    int frameLengthBitsLength = 16;
    int framesCountBitsLength = 16;
    int protocolIdBitsLength = 32;
    int sessionIdBitsLength = 32;
    int compositeChecksumBitsLength = 128;
    int checksumBitsLength = 128;
    int dataBitsLength = 256 * 8;

    int totalFrameSize = frameIndexBitsLength +
        frameLengthBitsLength +
        dataBitsLength +
        checksumBitsLength;

    int asciiCharacterCountInFrame = dataBitsLength ~/ 8;

    return FrameSettingsModel(
      frameIndexBitsLength: frameIndexBitsLength,
      frameLengthBitsLength: frameLengthBitsLength,
      framesCountBitsLength: framesCountBitsLength,
      protocolIdBitsLength: protocolIdBitsLength,
      sessionIdBitsLength: sessionIdBitsLength,
      compositeChecksumBitsLength: compositeChecksumBitsLength,
      checksumBitsLength: checksumBitsLength,
      dataBitsLength: dataBitsLength,
      frameSize: totalFrameSize,
      asciiCharacterCountInFrame: asciiCharacterCountInFrame,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    frameIndexBitsLength,
    frameLengthBitsLength,
    framesCountBitsLength,
    protocolIdBitsLength,
    sessionIdBitsLength,
    compositeChecksumBitsLength,
    checksumBitsLength,
    dataBitsLength,
    frameSize,
    asciiCharacterCountInFrame,
  ];
}
