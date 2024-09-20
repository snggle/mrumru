import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_protocol_manager.dart';

class FrameDto {
  static FrameModel fromBytes(List<int> bytes, {bool isFirstFrameBool = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    int offset = 0;

    int frameIndex = byteData.getUint16(offset);
    offset += 2;
    int frameLength = byteData.getUint16(offset);
    offset += 2;

    int framesCount = 0;
    int sessionId = 0;
    FrameProtocolManager protocolManager = FrameProtocolManager.defaultProtocol();
    Uint8List compositeChecksum = Uint8List(16);

    if (isFirstFrameBool) {
      framesCount = byteData.getUint16(offset);
      offset += 2;
      int protocolId = byteData.getUint32(offset);
      offset += 4;
      protocolManager = FrameProtocolManager.fromProtocolId(protocolId);
      sessionId = byteData.getUint32(offset);
      offset += 4;
      compositeChecksum = Uint8List.fromList(bytes.sublist(offset, offset + 16));
      offset += 16;
    }

    int dataLength = frameLength - (isFirstFrameBool ? 2 + 2 + 2 + 4 + 4 + 16 + 16 : 2 + 2 + 16);
    Uint8List rawDataBytes = Uint8List.fromList(bytes.sublist(offset, offset + dataLength));
    String rawData = String.fromCharCodes(rawDataBytes);
    offset += dataLength;

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

  static List<int> toBytes(FrameModel frameModel, {bool isFirstFrameBool = true}) {
    Uint8List rawDataBytes = Uint8List.fromList(frameModel.rawData.codeUnits);

    int totalLength = 4 + rawDataBytes.length + 16;
    if (isFirstFrameBool) {
      totalLength += 2 + 4 + 4 + 16;
    }

    ByteData byteData = ByteData(totalLength);
    int offset = 0;

    byteData.setUint16(offset, frameModel.frameIndex);
    offset += 2;
    byteData.setUint16(offset, frameModel.frameLength);
    offset += 2;

    if (isFirstFrameBool) {
      byteData.setUint16(offset, frameModel.framesCount);
      offset += 2;
      byteData.setUint32(offset, frameModel.protocolManager.protocolId);
      offset += 4;
      byteData.setUint32(offset, frameModel.sessionId);
      offset += 4;
      byteData.buffer.asUint8List().setRange(offset, offset + 16, frameModel.compositeChecksum);
      offset += 16;
    }

    byteData.buffer.asUint8List().setRange(offset, offset + rawDataBytes.length, rawDataBytes);
    offset += rawDataBytes.length;

    byteData.buffer.asUint8List().setRange(offset, offset + 16, frameModel.frameChecksum);

    return byteData.buffer.asUint8List();
  }
}
