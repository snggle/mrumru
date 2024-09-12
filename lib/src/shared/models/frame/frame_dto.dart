import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
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
    int protocolId = 0;
    int sessionId = 0;
    int compressionMethod = 0;
    int encodingMethod = 0;
    int protocolType = 0;
    int versionNumber = 0;
    int compositeChecksum = 0;

    if (isFirstFrame) {
      framesCount = byteData.getUint16(offset);
      offset += 2;
      protocolId = byteData.getUint32(offset);
      offset += 4;
      sessionId = byteData.getUint32(offset);
      offset += 4;
      compressionMethod = byteData.getUint8(offset);
      offset += 1;
      encodingMethod = byteData.getUint8(offset);
      offset += 1;
      protocolType = byteData.getUint8(offset);
      offset += 1;
      versionNumber = byteData.getUint8(offset);
      offset += 1;
      compositeChecksum = byteData.getUint32(offset);
      offset += 4;
    }

    Uint8List rawDataBytes = Uint8List.sublistView(byteData, offset, frameLength);
    String rawData = BinaryUtils.convertBinaryToAscii(
        rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());

    int frameChecksum = byteData.getUint16(offset);

    return FrameModel(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolId: protocolId,
      sessionId: sessionId,
      compressionMethod: compressionMethod,
      encodingMethod: encodingMethod,
      protocolType: protocolType,
      versionNumber: versionNumber,
      compositeChecksum: compositeChecksum,
      rawData: rawData,
    );
  }


  static List<int> toBytes(FrameModel frameModel, {bool isFirstFrame = true}) {
    ByteData byteData = ByteData(frameModel.frameLength);
    int offset = 0;

    byteData.setUint16(offset, frameModel.frameIndex);
    offset += 2;
    byteData.setUint16(offset, frameModel.frameLength);
    offset += 2;

    if (isFirstFrame) {
      byteData.setUint16(offset, frameModel.framesCount);
      offset += 2;
      byteData.setUint32(offset, frameModel.protocolId);
      offset += 4;
      byteData.setUint32(offset, frameModel.sessionId);
      offset += 4;
      byteData.setUint8(offset, frameModel.compressionMethod);
      offset += 1;
      byteData.setUint8(offset, frameModel.encodingMethod);
      offset += 1;
      byteData.setUint8(offset, frameModel.protocolType);
      offset += 1;
      byteData.setUint8(offset, frameModel.versionNumber);
      offset += 1;
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
