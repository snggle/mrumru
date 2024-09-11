import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';
import 'package:mrumru/src/shared/models/frame/frame_dto.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

class FrameModel extends Equatable {
  final int frameIndex;
  final int frameLength;
  final int framesCount;
  final Uint8List compositeChecksum;
  final int sessionId;
  final String rawData;
  final Uint8List frameChecksum;
  final FrameProtocolManager protocolManager;

  FrameModel({
    required this.frameIndex,
    required this.frameLength,
    required this.framesCount,
    required this.compositeChecksum,
    required this.sessionId,
    required this.rawData,
    required this.protocolManager,
  }) : frameChecksum = CryptoUtils.calcChecksum(text: rawData);

  /// Converts the frame into its binary string representation.
  String get binaryString {
    List<int> frameBytes = FrameDto.toBytes(this, isFirstFrameBool: frameIndex == 0);
    return frameBytes
        .map((int byte) => byte.toRadixString(2).padLeft(8, '0'))
        .join();
  }

  /// Calculates the total length of the audio transfer based on frames.
  int calculateTransferWavLength(AudioSettingsModel audioSettingsModel) {
    return (framesCount *
        frameLength /
        2 *
        audioSettingsModel.sampleSize *
        audioSettingsModel.sampleRate)
        .toInt();
  }

  @override
  List<Object?> get props => <Object?>[
    frameIndex,
    frameLength,
    framesCount,
    compositeChecksum,
    sessionId,
    rawData,
    frameChecksum,
    protocolManager,
  ];
}
