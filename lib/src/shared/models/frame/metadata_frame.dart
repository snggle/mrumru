import 'dart:typed_data';
import 'package:mrumru/src/frame/protocol/frame_protocol_id.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

class MetadataFrame extends AFrameBase {
  static const int frameIndexSize = 2;
  static const int frameLengthSize = 2;
  static const int framesCountSize = 2;
  static const int protocolIDSize = 4;
  static const int sessionIdSize = 4;
  static const int checksumSize = 16;
  static const int dataSize = 0;

  final int framesCount;
  final FrameProtocolID frameProtocolID;
  final int sessionId;
  final Uint8List compositeChecksum;

  MetadataFrame({
    required int frameIndex,
    required int frameLength,
    required Uint8List frameChecksum,
    required this.framesCount,
    required this.frameProtocolID,
    required this.sessionId,
    required this.compositeChecksum,
  }) : super(
          frameIndex: frameIndex,
          frameLength: frameLength,
          frameChecksum: frameChecksum,
        );

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      ...BinaryUtils.intToBytes(frameIndex, frameIndexSize),
      ...BinaryUtils.intToBytes(frameLength, frameLengthSize),
      ...BinaryUtils.intToBytes(framesCount, framesCountSize),
      ...frameProtocolID.toBytes(),
      ...BinaryUtils.intToBytes(sessionId, sessionIdSize),
      ...compositeChecksum,
      ...frameChecksum,
    ]);
  }

  static MetadataFrame fromBytes(Uint8List bytes) {
    int offset = 0;
    int frameIndex = ByteData.sublistView(bytes.sublist(offset, offset + frameIndexSize)).getUint16(0);
    offset += frameIndexSize;
    int frameLength = ByteData.sublistView(bytes.sublist(offset, offset + frameLengthSize)).getUint16(0);
    offset += frameLengthSize;
    int framesCount = ByteData.sublistView(bytes.sublist(offset, offset + framesCountSize)).getUint16(0);
    offset += framesCountSize;
    FrameProtocolID protocolId = FrameProtocolID.fromBytes(bytes.sublist(offset, offset + protocolIDSize));
    offset += protocolIDSize;
    int sessionId = ByteData.sublistView(bytes.sublist(offset, offset + sessionIdSize)).getUint32(0);
    offset += sessionIdSize;
    Uint8List compositeChecksum = bytes.sublist(offset, offset + checksumSize);
    offset += checksumSize;
    Uint8List frameChecksum = bytes.sublist(offset, offset + checksumSize);

    return MetadataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      frameChecksum: frameChecksum,
      framesCount: framesCount,
      frameProtocolID: protocolId,
      sessionId: sessionId,
      compositeChecksum: compositeChecksum,
    );
  }

  static int calculateFrameLength() {
    return frameIndexSize + frameLengthSize + framesCountSize + protocolIDSize + sessionIdSize + checksumSize + dataSize + checksumSize;
  }
}
