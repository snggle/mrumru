import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';

class FrameDto {
  static FrameModel fromBytes(List<int> bytes, {bool isFirstFrame = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    int offset = 0;

    int frameIndex = byteData.getUint16(offset);
    offset += 2;
    int frameLength = byteData.getUint16(offset);
    offset += 2;

    int framesCount = 0;
    int sessionId = 0;
    FrameProtocolManager protocolManager = FrameProtocolManager.defaultProtocol();
    int compositeChecksum = 0;

    if (isFirstFrame) {
      framesCount = byteData.getUint16(offset);
      offset += 2;
      int protocolId = byteData.getUint32(offset);
      offset += 4;
      protocolManager = FrameProtocolManager.fromProtocolId(protocolId);
      sessionId = byteData.getUint32(offset);
      offset += 4;
      compositeChecksum = byteData.getUint32(offset);
      offset += 4;
    }

    int dataLength = frameLength - (isFirstFrame ? 20 : 6);

    Uint8List rawDataBytes =
    Uint8List.sublistView(byteData, offset, offset + dataLength);
    String rawData = String.fromCharCodes(rawDataBytes);
    offset += dataLength;

    int frameChecksum = byteData.getUint16(offset);

    return FrameModel(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      compositeChecksum: compositeChecksum,
      sessionId: sessionId,
      rawData: rawData,
      protocolManager: protocolManager,
    );
  }

  static List<int> toBytes(FrameModel frameModel, {bool isFirstFrame = true}) {
    Uint8List rawDataBytes = Uint8List.fromList(frameModel.rawData.codeUnits);

    int totalLength = 4 + rawDataBytes.length + 2; 
    if (isFirstFrame) {
      totalLength += 2 + 4 + 4 + 4;
    }

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
      byteData.setUint32(offset, frameModel.sessionId);
      offset += 4;
      byteData.setUint32(offset, frameModel.compositeChecksum);
      offset += 4;
    }

    byteData.buffer
        .asUint8List()
        .setRange(offset, offset + rawDataBytes.length, rawDataBytes);
    offset += rawDataBytes.length;

    byteData.setUint16(offset, frameModel.frameChecksum);

    return byteData.buffer.asUint8List();
  }
}
