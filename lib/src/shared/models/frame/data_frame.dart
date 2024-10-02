import 'dart:typed_data';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

class DataFrame extends AFrameBase {
  static const int frameIndexSize = 2;
  static const int frameLengthSize = 2;
  static const int checksumSize = 16;

  final String data;

  DataFrame({
    required int frameIndex,
    required int frameLength,
    required Uint8List frameChecksum,
    required this.data,
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
      ...data.codeUnits,
      ...frameChecksum,
    ]);
  }

  static DataFrame fromBytes(Uint8List bytes) {
    int offset = 0;
    int frameIndex = ByteData.sublistView(bytes.sublist(offset, offset + frameIndexSize)).getUint16(0);
    offset += frameIndexSize;
    int frameLength = ByteData.sublistView(bytes.sublist(offset, offset + frameLengthSize)).getUint16(0);
    offset += frameLengthSize;
    int dataLength = frameLength - frameIndexSize - frameLengthSize - checksumSize;
    String data = String.fromCharCodes(bytes.sublist(offset, offset + dataLength));
    offset += dataLength;
    Uint8List frameChecksum = bytes.sublist(offset, offset + checksumSize);

    return DataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      frameChecksum: frameChecksum,
      data: data,
    );
  }

  static int calculateFrameLength(int dataLength) {
    return frameIndexSize + frameLengthSize + dataLength + checksumSize;
  }
}
