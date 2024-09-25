import 'package:equatable/equatable.dart';

class FrameSettingsModel with EquatableMixin {
  final int asciiCharacterCountInFrameInt;
  final int checksumBitsLengthInt;
  final int compositeChecksumBitsLengthInt;
  final int dataBitsLengthInt;
  final int frameIndexBitsLengthInt;
  final int frameLengthBitsLengthInt;
  final int frameSizeInt;
  final int framesCountBitsLengthInt;
  final int protocolIdBitsLengthInt;
  final int sessionIdBitsLengthInt;

  FrameSettingsModel({
    required this.asciiCharacterCountInFrameInt,
    required this.checksumBitsLengthInt,
    required this.compositeChecksumBitsLengthInt,
    required this.dataBitsLengthInt,
    required this.frameIndexBitsLengthInt,
    required this.frameLengthBitsLengthInt,
    required this.frameSizeInt,
    required this.framesCountBitsLengthInt,
    required this.protocolIdBitsLengthInt,
    required this.sessionIdBitsLengthInt,
  });

  factory FrameSettingsModel.withDefaults() {
    const int frameIndexBitsLengthInt = 16;
    const int frameLengthBitsLengthInt = 16;
    const int framesCountBitsLengthInt = 16;
    const int protocolIdBitsLengthInt = 32;
    const int sessionIdBitsLengthInt = 128;
    const int compositeChecksumBitsLengthInt = 128;
    const int checksumBitsLengthInt = 128;
    const int dataBitsLengthInt = 256 * 8;

    const int frameSizeInt = frameIndexBitsLengthInt +
        frameLengthBitsLengthInt +
        framesCountBitsLengthInt +
        protocolIdBitsLengthInt +
        sessionIdBitsLengthInt +
        compositeChecksumBitsLengthInt +
        dataBitsLengthInt +
        checksumBitsLengthInt;

    const int asciiCharacterCountInFrameInt = dataBitsLengthInt ~/ 8;

    return FrameSettingsModel(
      asciiCharacterCountInFrameInt: asciiCharacterCountInFrameInt,
      checksumBitsLengthInt: checksumBitsLengthInt,
      compositeChecksumBitsLengthInt: compositeChecksumBitsLengthInt,
      dataBitsLengthInt: dataBitsLengthInt,
      frameIndexBitsLengthInt: frameIndexBitsLengthInt,
      frameLengthBitsLengthInt: frameLengthBitsLengthInt,
      frameSizeInt: frameSizeInt,
      framesCountBitsLengthInt: framesCountBitsLengthInt,
      protocolIdBitsLengthInt: protocolIdBitsLengthInt,
      sessionIdBitsLengthInt: sessionIdBitsLengthInt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    asciiCharacterCountInFrameInt,
    checksumBitsLengthInt,
    compositeChecksumBitsLengthInt,
    dataBitsLengthInt,
    frameIndexBitsLengthInt,
    frameLengthBitsLengthInt,
    frameSizeInt,
    framesCountBitsLengthInt,
    protocolIdBitsLengthInt,
    sessionIdBitsLengthInt,
  ];
}
