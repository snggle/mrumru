import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';

class DataFrame extends ABaseFrame {
  @override
  final int frameIndexInt;
  @override
  final int frameLengthInt;
  final String dataString;
  final String frameChecksumString;

  DataFrame({
    required this.frameIndexInt,
    required this.frameLengthInt,
    required this.dataString,
    required this.frameChecksumString,
  });

  factory DataFrame.fromBytes(Uint8List bytesUint8List, FrameSettingsModel frameSettingsModel) {
    int offsetInt = 0;

    final int frameIndexInt = _getUintN(bytesUint8List, offsetInt, frameSettingsModel.frameIndexBitsLengthInt);
    offsetInt += frameSettingsModel.frameIndexBitsLengthInt ~/ 8;

    final int frameLengthInt = _getUintN(bytesUint8List, offsetInt, frameSettingsModel.frameLengthBitsLengthInt);
    offsetInt += frameSettingsModel.frameLengthBitsLengthInt ~/ 8;

    final int dataLengthInt = frameLengthInt -
        (frameSettingsModel.frameIndexBitsLengthInt + frameSettingsModel.frameLengthBitsLengthInt + frameSettingsModel.checksumBitsLengthInt) ~/ 8;

    final String dataString = String.fromCharCodes(bytesUint8List.sublist(offsetInt, offsetInt + dataLengthInt));
    offsetInt += dataLengthInt;

    final Uint8List frameChecksumBytesUint8List = bytesUint8List.sublist(offsetInt, offsetInt + frameSettingsModel.checksumBitsLengthInt ~/ 8);
    final String frameChecksumString = String.fromCharCodes(frameChecksumBytesUint8List);

    return DataFrame(
      dataString: dataString,
      frameChecksumString: frameChecksumString,
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
    );
  }

  @override
  Uint8List toBytes(FrameSettingsModel frameSettingsModel) {
    final List<int> bytesIntList = <int>[];

    _addUintN(bytesIntList, frameIndexInt, frameSettingsModel.frameIndexBitsLengthInt);
    _addUintN(bytesIntList, frameLengthInt, frameSettingsModel.frameLengthBitsLengthInt);

    bytesIntList
      ..addAll(dataString.codeUnits)
      ..addAll(frameChecksumString.codeUnits);

    return Uint8List.fromList(bytesIntList);
  }

  static int _getUintN(Uint8List bytesUint8List, int offsetInt, int bitLengthInt) {
    final int byteLengthInt = bitLengthInt ~/ 8;
    int valueInt = 0;
    for (int i = 0; i < byteLengthInt; i++) {
      valueInt = (valueInt << 8) | bytesUint8List[offsetInt + i];
    }
    return valueInt;
  }

  static void _addUintN(List<int> bytesIntList, int valueInt, int bitLengthInt) {
    final int byteLengthInt = bitLengthInt ~/ 8;
    for (int i = byteLengthInt - 1; i >= 0; i--) {
      bytesIntList.add((valueInt >> (8 * i)) & 0xFF);
    }
  }

  @override
  String get binaryString {
    Uint8List bytesUint8List = toBytes(FrameSettingsModel.withDefaults());
    return bytesUint8List.map((int byteInt) => byteInt.toRadixString(2).padLeft(8, '0')).join();
  }
}
