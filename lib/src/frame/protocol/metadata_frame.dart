import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/frame/protocol/a_base_frame.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_id.dart';
import 'package:mrumru/src/shared/utils/byte_utils.dart';

class MetadataFrame extends ABaseFrame {
  final int framesCount;
  final FrameProtocolID protocolID;
  final String sessionId;
  final Uint8List compositeChecksum;
  final String _dataString;
  final Uint8List frameChecksum;

  MetadataFrame({
    required int frameIndex,
    required int frameLength,
    required this.framesCount,
    required this.protocolID,
    required this.sessionId,
    required this.compositeChecksum,
    required String dataString,
    required this.frameChecksum,
  })  : _dataString = dataString,
        super(
          frameIndex: frameIndex,
          frameLength: frameLength,
        );

  @override
  String get dataString => _dataString;

  @override
  Uint8List toBytes() {
    final List<int> bytes = <int>[
      ...ByteUtils.intToBytes(frameIndex, 2),
      ...ByteUtils.intToBytes(frameLength, 2),
      ...ByteUtils.intToBytes(framesCount, 2),
      ...protocolID.toBytes(),
      ...utf8.encode(sessionId),
      ...compositeChecksum,
      ...utf8.encode(_dataString),
      ...frameChecksum
    ];
    return Uint8List.fromList(bytes);
  }

  @override
  String get binaryString {
    return toBytes().map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }

  factory MetadataFrame.fromBytes(Uint8List bytes) {
    int offset = 0;
    final int frameIndex = ByteUtils.bytesToInt(bytes.sublist(offset, offset + 2));
    offset += 2;
    final int frameLength = ByteUtils.bytesToInt(bytes.sublist(offset, offset + 2));
    offset += 2;
    final int framesCount = ByteUtils.bytesToInt(bytes.sublist(offset, offset + 2));
    offset += 2;
    final FrameProtocolID protocolID = FrameProtocolID.fromBytes(bytes.sublist(offset, offset + 4));
    offset += 4;
    final String sessionId = utf8.decode(bytes.sublist(offset, offset + 16));
    offset += 16;
    final Uint8List compositeChecksum = bytes.sublist(offset, offset + 16);
    offset += 16;
    final int dataLength = frameLength - 2 - 2 - 2 - 4 - 16 - 16 - 16;
    final String dataString = utf8.decode(bytes.sublist(offset, offset + dataLength));
    offset += dataLength;
    final Uint8List frameChecksum = bytes.sublist(offset, offset + 16);

    return MetadataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolID: protocolID,
      sessionId: sessionId,
      compositeChecksum: compositeChecksum,
      dataString: dataString,
      frameChecksum: frameChecksum,
    );
  }

  void computeChecksums() {
    final Uint8List bytesWithoutChecksum = toBytes().sublist(0, toBytes().length - 16);
    frameChecksum.setAll(0, FrameProcessor.computeFrameChecksum(bytesWithoutChecksum));
  }

  void updateCompositeChecksum(Uint8List newCompositeChecksum) {
    compositeChecksum.setAll(0, newCompositeChecksum);
    computeChecksums();
  }
}
