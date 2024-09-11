import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

class FrameDto {
  /// Converts a list of bytes into a FrameModel object.
  static FrameModel fromBytes(List<int> bytes, {bool isFirstFrame = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    int offset = 0;

    int frameIndex = byteData.getUint16(offset);
    offset += 2;
    int frameLength = byteData.getUint16(offset);
    offset += 2;

    if (isFirstFrame) {
      int framesCount = byteData.getUint16(offset);
      offset += 2;
      int protocolId = byteData.getUint32(offset);
      offset += 4;
      int sessionId = byteData.getUint32(offset);
      offset += 4;
      int compressionMethod = byteData.getUint8(offset);
      offset += 1;
      int encodingMethod = byteData.getUint8(offset);
      offset += 1;
      int protocolType = byteData.getUint8(offset);
      offset += 1;
      int versionNumber = byteData.getUint8(offset);
      offset += 1;
      int compositeChecksum = byteData.getUint32(offset);
      offset += 4;
      int frameChecksum = byteData.getUint16(offset);
      offset += 2;

      Uint8List rawDataBytes = Uint8List.sublistView(byteData, offset);
      String rawData = BinaryUtils.convertBinaryToAscii(rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());

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
    } else {
      Uint8List rawDataBytes = Uint8List.sublistView(byteData, offset, offset + (frameLength - offset));
      String rawData = BinaryUtils.convertBinaryToAscii(rawDataBytes.map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join());
      int frameChecksum = byteData.getUint16(offset + rawDataBytes.length);

      return FrameModel(
        frameIndex: frameIndex,
        frameLength: frameLength,
        framesCount: 0, // No framesCount in non-first frames
        protocolId: 0,  // No protocolId in non-first frames
        sessionId: 0,   // No sessionId in non-first frames
        compressionMethod: 0, // No compressionMethod in non-first frames
        encodingMethod: 0,    // No encodingMethod in non-first frames
        protocolType: 0,      // No protocolType in non-first frames
        versionNumber: 0,     // No versionNumber in non-first frames
        compositeChecksum: 0, // No compositeChecksum in non-first frames
        rawData: rawData,
      );
    }
  }

  /// Converts a FrameModel object into a list of bytes.
  static List<int> toBytes(FrameModel frameModel, {bool isFirstFrame = true}) {
    ByteData byteData;

    if (isFirstFrame) {
      byteData = ByteData(frameModel.frameLength);

      int offset = 0;
      byteData.setUint16(offset, frameModel.frameIndex);
      offset += 2;
      byteData.setUint16(offset, frameModel.frameLength);
      offset += 2;
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
      byteData.setUint16(offset, int.parse(frameModel.frameChecksum, radix: 2));
      offset += 2;

      Uint8List rawDataBytes = Uint8List.fromList(frameModel.rawData.codeUnits);
      for (int i = 0; i < rawDataBytes.length; i++) {
        byteData.setUint8(offset++, rawDataBytes[i]);
      }

    } else {

      byteData = ByteData(frameModel.frameLength);

      int offset = 0;
      byteData.setUint16(offset, frameModel.frameIndex);
      offset += 2;
      byteData.setUint16(offset, frameModel.frameLength);
      offset += 2;

      Uint8List rawDataBytes = Uint8List.fromList(frameModel.rawData.codeUnits);
      for (int i = 0; i < rawDataBytes.length; i++) {
        byteData.setUint8(offset++, rawDataBytes[i]);
      }

      byteData.setUint16(offset, int.parse(frameModel.frameChecksum, radix: 2));
    }

    return byteData.buffer.asUint8List();
  }
}
