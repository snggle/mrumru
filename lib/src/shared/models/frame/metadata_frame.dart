import 'dart:typed_data';

class MetadataFrame {
  static const int frameIndexSize = 2;
  static const int frameLengthSize = 2;
  static const int framesCountSize = 2;
  static const int protocolIdSize = 4;
  static const int sessionIdSize = 16;
  static const int compositeChecksumSize = 16;
  static const int frameChecksumSize = 16;

  final int frameIndex;
  final int frameLength;
  final int framesCount;
  final int protocolId;
  final String sessionId;
  final Uint8List compositeChecksum;
  final String data;
  final Uint8List frameChecksum;

  MetadataFrame({
    required this.frameIndex,
    required this.frameLength,
    required this.framesCount,
    required this.protocolId,
    required this.sessionId,
    required this.compositeChecksum,
    required this.data,
    required this.frameChecksum,
  });

  factory MetadataFrame.fromBytes(Uint8List bytes) {
    int offset = 0;
    int frameIndex = _getUint16(bytes, offset);
    offset += frameIndexSize;
    int frameLength = _getUint16(bytes, offset);
    offset += frameLengthSize;
    int framesCount = _getUint16(bytes, offset);
    offset += framesCountSize;
    int protocolId = _getUint32(bytes, offset);
    offset += protocolIdSize;
    Uint8List sessionIdBytes = bytes.sublist(offset, offset + sessionIdSize);
    String sessionId = _bytesToUuidString(sessionIdBytes);
    offset += sessionIdSize;
    Uint8List compositeChecksum = bytes.sublist(offset, offset + compositeChecksumSize);
    offset += compositeChecksumSize;
    int dataLength = frameLength -
        (frameIndexSize +
            frameLengthSize +
            framesCountSize +
            protocolIdSize +
            sessionIdSize +
            compositeChecksumSize +
            frameChecksumSize);
    String data = String.fromCharCodes(bytes.sublist(offset, offset + dataLength));
    offset += dataLength;
    Uint8List frameChecksum = bytes.sublist(offset, offset + frameChecksumSize);

    return MetadataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      framesCount: framesCount,
      protocolId: protocolId,
      sessionId: sessionId,
      compositeChecksum: compositeChecksum,
      data: data,
      frameChecksum: frameChecksum,
    );
  }

  Uint8List toBytes() {
    List<int> bytes = <int>[];
    _addUint16(bytes, frameIndex);
    _addUint16(bytes, frameLength);
    _addUint16(bytes, framesCount);
    _addUint32(bytes, protocolId);
    Uint8List sessionIdBytes = _uuidStringToBytes(sessionId);
    bytes..addAll(sessionIdBytes)
    ..addAll(compositeChecksum)
    ..addAll(data.codeUnits)
    ..addAll(frameChecksum);
    return Uint8List.fromList(bytes);
  }

  static int _getUint16(Uint8List bytes, int offset) {
    return (bytes[offset] << 8) | bytes[offset + 1];
  }

  static int _getUint32(Uint8List bytes, int offset) {
    return (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3];
  }

  static void _addUint16(List<int> bytes, int value) {
    bytes..add((value >> 8) & 0xFF)
    ..add(value & 0xFF);
  }

  static void _addUint32(List<int> bytes, int value) {
    bytes..add((value >> 24) & 0xFF)
    ..add((value >> 16) & 0xFF)
    ..add((value >> 8) & 0xFF)
    ..add(value & 0xFF);
  }

  static String _bytesToUuidString(Uint8List bytes) {
    return '';
  }

  static Uint8List _uuidStringToBytes(String uuid) {
    // Implement conversion from UUID string to bytes
    return Uint8List(16);
  }
}
