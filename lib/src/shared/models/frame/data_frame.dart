import 'dart:typed_data';

class DataFrame {
  static const int frameIndexSize = 2;
  static const int frameLengthSize = 2;
  static const int frameChecksumSize = 16;

  final int frameIndex;
  final int frameLength;
  final String data;
  final Uint8List frameChecksum;

  DataFrame({
    required this.frameIndex,
    required this.frameLength,
    required this.data,
    required this.frameChecksum,
  });

  factory DataFrame.fromBytes(Uint8List bytes) {
    int offset = 0;
    int frameIndex = _getUint16(bytes, offset);
    offset += frameIndexSize;
    int frameLength = _getUint16(bytes, offset);
    offset += frameLengthSize;
    int dataLength = frameLength - (frameIndexSize + frameLengthSize + frameChecksumSize);
    String data = String.fromCharCodes(bytes.sublist(offset, offset + dataLength));
    offset += dataLength;
    Uint8List frameChecksum = bytes.sublist(offset, offset + frameChecksumSize);

    return DataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      data: data,
      frameChecksum: frameChecksum,
    );
  }

  Uint8List toBytes() {
    List<int> bytes = <int>[];
    _addUint16(bytes, frameIndex);
    _addUint16(bytes, frameLength);
    bytes..addAll(data.codeUnits)
    ..addAll(frameChecksum);
    return Uint8List.fromList(bytes);
  }

  static int _getUint16(Uint8List bytes, int offset) {
    return (bytes[offset] << 8) | bytes[offset + 1];
  }

  static void _addUint16(List<int> bytes, int value) {
    bytes..add((value >> 8) & 0xFF)
    ..add(value & 0xFF);
  }
}
