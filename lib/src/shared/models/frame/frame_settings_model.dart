import 'package:equatable/equatable.dart';

class FrameSettingsModel with EquatableMixin {
  final int frameIndexBitsLength;
  final int framesCountBitsLength;
  final int dataBitsLength;
  final int checksumBitsLength;

  final int protocolIdBitsLength;
  final int sessionIdBitsLength;
  final int compressionMethodBitsLength;
  final int encodingMethodBitsLength;
  final int protocolTypeBitsLength;
  final int versionNumberBitsLength;
  final int compositeChecksumBitsLength;

  final int frameSize;
  final int asciiCharacterCountInFrame;

  FrameSettingsModel({
    required this.frameIndexBitsLength,
    required this.framesCountBitsLength,
    required this.dataBitsLength,
    required this.checksumBitsLength,
    required this.protocolIdBitsLength,
    required this.sessionIdBitsLength,
    required this.compressionMethodBitsLength,
    required this.encodingMethodBitsLength,
    required this.protocolTypeBitsLength,
    required this.versionNumberBitsLength,
    required this.compositeChecksumBitsLength,
    required this.frameSize,
    required this.asciiCharacterCountInFrame,
  });

  factory FrameSettingsModel.withDefaults() {
    int frameIndexBitsLength = 8;
    int framesCountBitsLength = 8;
    int dataBitsLength = 32;
    int checksumBitsLength = 16;
    int protocolIdBitsLength = 32;
    int sessionIdBitsLength = 32;
    int compressionMethodBitsLength = 8;
    int encodingMethodBitsLength = 8;
    int protocolTypeBitsLength = 8;
    int versionNumberBitsLength = 8;
    int compositeChecksumBitsLength = 32;

    int totalFrameSize = frameIndexBitsLength +
        framesCountBitsLength +
        dataBitsLength +
        checksumBitsLength +
        protocolIdBitsLength +
        sessionIdBitsLength +
        compressionMethodBitsLength +
        encodingMethodBitsLength +
        protocolTypeBitsLength +
        versionNumberBitsLength +
        compositeChecksumBitsLength;

    return FrameSettingsModel(
      frameIndexBitsLength: frameIndexBitsLength,
      framesCountBitsLength: framesCountBitsLength,
      dataBitsLength: dataBitsLength,
      checksumBitsLength: checksumBitsLength,
      protocolIdBitsLength: protocolIdBitsLength,
      sessionIdBitsLength: sessionIdBitsLength,
      compressionMethodBitsLength: compressionMethodBitsLength,
      encodingMethodBitsLength: encodingMethodBitsLength,
      protocolTypeBitsLength: protocolTypeBitsLength,
      versionNumberBitsLength: versionNumberBitsLength,
      compositeChecksumBitsLength: compositeChecksumBitsLength,
      frameSize: totalFrameSize,
      asciiCharacterCountInFrame: dataBitsLength ~/ 8,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    frameIndexBitsLength,
    framesCountBitsLength,
    dataBitsLength,
    checksumBitsLength,
    protocolIdBitsLength,
    sessionIdBitsLength,
    compressionMethodBitsLength,
    encodingMethodBitsLength,
    protocolTypeBitsLength,
    versionNumberBitsLength,
    compositeChecksumBitsLength,
    frameSize,
    asciiCharacterCountInFrame,
  ];
}
