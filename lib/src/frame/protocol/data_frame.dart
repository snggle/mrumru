import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';

class DataFrame extends ABaseFrame {
  @override
  final int frameIndexInt;
  @override
  final int frameLengthInt;
  final String dataString;
  final Uint8List frameChecksumUint8List;

  DataFrame({
    required this.frameIndexInt,
    required this.frameLengthInt,
    required this.dataString,
    required this.frameChecksumUint8List,
  });

  factory DataFrame.fromBytes(Uint8List bytesUint8List, FrameSettingsModel frameSettingsModel) {
    int offset = 0;

    int frameIndexInt = _readUintN(bytesUint8List, offset, frameSettingsModel.frameIndexBitsLengthInt);
    offset += frameSettingsModel.frameIndexBitsLengthInt ~/ 8;

    int frameLengthInt = _readUintN(bytesUint8List, offset, frameSettingsModel.frameLengthBitsLengthInt);
    offset += frameSettingsModel.frameLengthBitsLengthInt ~/ 8;

    int dataLength = frameLengthInt -
        ((frameSettingsModel.frameIndexBitsLengthInt +
            frameSettingsModel.frameLengthBitsLengthInt +
            frameSettingsModel.checksumBitsLengthInt) ~/
            8);
    String dataString = utf8.decode(bytesUint8List.sublist(offset, offset + dataLength));
    offset += dataLength;

    int frameChecksumLength = frameSettingsModel.checksumBitsLengthInt ~/ 8;
    Uint8List frameChecksumUint8List = bytesUint8List.sublist(offset, offset + frameChecksumLength);

    return DataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      dataString: dataString,
      frameChecksumUint8List: frameChecksumUint8List,
    );
  }

  @override
  Uint8List toBytes(FrameSettingsModel frameSettingsModel) {
    List<int> bytesIntList = <int>[];

    _addUintN(bytesIntList, frameIndexInt, frameSettingsModel.frameIndexBitsLengthInt);
    _addUintN(bytesIntList, frameLengthInt, frameSettingsModel.frameLengthBitsLengthInt);

    bytesIntList..addAll(utf8.encode(dataString))
    ..addAll(frameChecksumUint8List);

    return Uint8List.fromList(bytesIntList);
  }

  @override
  String get binaryString {
    Uint8List bytesUint8List = toBytes(FrameSettingsModel.withDefaults());
    return bytesUint8List.map((int byteInt) => byteInt.toRadixString(2).padLeft(8, '0')).join();
  }

  static void _addUintN(List<int> bytesIntList, int valueInt, int bitLengthInt) {
    int byteLengthInt = bitLengthInt ~/ 8;
    for (int i = byteLengthInt - 1; i >= 0; i--) {
      bytesIntList.add((valueInt >> (8 * i)) & 0xFF);
    }
  }

  static int _readUintN(Uint8List bytesUint8List, int offsetInt, int bitLengthInt) {
    int valueInt = 0;
    int byteLengthInt = bitLengthInt ~/ 8;
    for (int i = 0; i < byteLengthInt; i++) {
      valueInt = (valueInt << 8) | bytesUint8List[offsetInt + i];
    }
    return valueInt;
  }
}
