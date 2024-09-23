import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/shared/utils/byte_utils.dart';

class DataFrame extends ABaseFrame {
  final String _dataString;
  final Uint8List frameChecksum;

  DataFrame({
    required int frameIndex,
    required int frameLength,
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
      ...utf8.encode(_dataString),
      ...frameChecksum
    ];
    return Uint8List.fromList(bytes);
  }

  @override
  String get binaryString {
    return toBytes().map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }

  factory DataFrame.fromBytes(Uint8List bytes) {
    int offset = 0;
    final int frameIndex = ByteUtils.bytesToInt(bytes.sublist(offset, offset + 2));
    offset += 2;
    final int frameLength = ByteUtils.bytesToInt(bytes.sublist(offset, offset + 2));
    offset += 2;
    final int dataLength = frameLength - 2 - 2 - 16;
    final String dataString = utf8.decode(bytes.sublist(offset, offset + dataLength));
    offset += dataLength;
    final Uint8List frameChecksum = bytes.sublist(offset, offset + 16);

    return DataFrame(
      frameIndex: frameIndex,
      frameLength: frameLength,
      dataString: dataString,
      frameChecksum: frameChecksum,
    );
  }

  void computeChecksum() {
    final Uint8List bytesWithoutChecksum = toBytes().sublist(0, toBytes().length - 16);
    frameChecksum.setAll(0, FrameProcessor.computeFrameChecksum(bytesWithoutChecksum));
  }
}
