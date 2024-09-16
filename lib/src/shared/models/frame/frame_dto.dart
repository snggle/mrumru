import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

class FrameDto {
  static FrameModel fromBytes(List<int> bytes, {bool isFirstFrame = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    int offset = 0;

    int frameIndex = byteData.getUint16(offset);
    offset += 2;
    int frameLength = byteData.getUint16(offset);
    offset += 2;

    int framesCount = 0;
    FrameProtocolManager protocolManager = FrameProtocolManager.defaultProtocol();
    int compositeChecksum = 0;

    if (isFirstFrame) {
      framesCount = byteData.getUint16(offset);
      offset += 2;
      int protocolId = byteData.getUint32(offset);
      offset += 4;
      protocolManager = FrameProtocolManager.fromProtocolId(protocolId);
      compositeChecksum = byteData.getUint32(offset);
      offset += 4;
    }

    Uint8List rawDataBytes = Uint8List.sublistView(byteData, offset, offset + frameLength);
    String rawData = BinaryUtils.convertBinaryToAscii(
        rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());

    int frameChecksum = byteData.getUint16(offset);

    return FrameModel(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      compositeChecksum: compositeChecksum,
      rawData: rawData,
      protocolManager: protocolManager,
    );
  }

  static List<int> toBytes(FrameModel frameModel, {bool isFirstFrame = true}) {
    int totalLength = frameModel.frameLength + (isFirstFrame ? 16 : 0);
    ByteData byteData = ByteData(totalLength);
    int offset = 0;

    byteData.setUint16(offset, frameModel.frameIndex);
    offset += 2;
    byteData.setUint16(offset, frameModel.frameLength);
    offset += 2;

    if (isFirstFrame) {
      byteData.setUint16(offset, frameModel.framesCount);
      offset += 2;
      byteData.setUint32(offset, frameModel.protocolManager.protocolId);
      offset += 4;
      byteData.setUint32(offset, frameModel.compositeChecksum);
      offset += 4;
    }

    Uint8List rawDataBytes = Uint8List.fromList(frameModel.rawData.codeUnits);
    for (int i = 0; i < rawDataBytes.length; i++) {
      byteData.setUint8(offset++, rawDataBytes[i]);
    }

    byteData.setUint16(offset, int.parse(frameModel.frameChecksum, radix: 2));

    return byteData.buffer.asUint8List();
  }
}
