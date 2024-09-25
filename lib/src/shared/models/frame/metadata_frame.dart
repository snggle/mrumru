import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';

class MetadataFrame extends ABaseFrame {
  @override
  final int frameIndexInt;
  @override
  final int frameLengthInt;
  final int framesCountInt;
  final int protocolIdInt;
  final String sessionIdString;
  final Uint8List compositeChecksumUint8List;
  final String dataString;
  final Uint8List frameChecksumUint8List;

  MetadataFrame({
    required this.frameIndexInt,
    required this.frameLengthInt,
    required this.framesCountInt,
    required this.protocolIdInt,
    required this.sessionIdString,
    required this.compositeChecksumUint8List,
    required this.dataString,
    required this.frameChecksumUint8List,
  });

  factory MetadataFrame.fromBytes(Uint8List bytesUint8List, FrameSettingsModel frameSettingsModel) {
    int offset = 0;

    int frameIndexInt = _readUintN(bytesUint8List, offset, frameSettingsModel.frameIndexBitsLengthInt);
    offset += frameSettingsModel.frameIndexBitsLengthInt ~/ 8;

    int frameLengthInt = _readUintN(bytesUint8List, offset, frameSettingsModel.frameLengthBitsLengthInt);
    offset += frameSettingsModel.frameLengthBitsLengthInt ~/ 8;

    int framesCountInt = _readUintN(bytesUint8List, offset, frameSettingsModel.framesCountBitsLengthInt);
    offset += frameSettingsModel.framesCountBitsLengthInt ~/ 8;

    int protocolIdInt = _readUintN(bytesUint8List, offset, frameSettingsModel.protocolIdBitsLengthInt);
    offset += frameSettingsModel.protocolIdBitsLengthInt ~/ 8;

    int sessionIdLength = frameSettingsModel.sessionIdBitsLengthInt ~/ 8;
    String sessionIdString = utf8.decode(bytesUint8List.sublist(offset, offset + sessionIdLength));
    offset += sessionIdLength;

    int compositeChecksumLength = frameSettingsModel.compositeChecksumBitsLengthInt ~/ 8;
    Uint8List compositeChecksumUint8List = bytesUint8List.sublist(offset, offset + compositeChecksumLength);
    offset += compositeChecksumLength;

    int dataLength = frameLengthInt -
        ((frameSettingsModel.frameIndexBitsLengthInt +
            frameSettingsModel.frameLengthBitsLengthInt +
            frameSettingsModel.framesCountBitsLengthInt +
            frameSettingsModel.protocolIdBitsLengthInt +
            frameSettingsModel.sessionIdBitsLengthInt +
            frameSettingsModel.compositeChecksumBitsLengthInt +
            frameSettingsModel.checksumBitsLengthInt) ~/
            8);
    String dataString = utf8.decode(bytesUint8List.sublist(offset, offset + dataLength));
    offset += dataLength;

    int frameChecksumLength = frameSettingsModel.checksumBitsLengthInt ~/ 8;
    Uint8List frameChecksumUint8List = bytesUint8List.sublist(offset, offset + frameChecksumLength);

    return MetadataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      framesCountInt: framesCountInt,
      protocolIdInt: protocolIdInt,
      sessionIdString: sessionIdString,
      compositeChecksumUint8List: compositeChecksumUint8List,
      dataString: dataString,
      frameChecksumUint8List: frameChecksumUint8List,
    );
  }

  @override
  Uint8List toBytes(FrameSettingsModel frameSettingsModel) {
    List<int> bytesIntList = <int>[];

    _addUintN(bytesIntList, frameIndexInt, frameSettingsModel.frameIndexBitsLengthInt);
    _addUintN(bytesIntList, frameLengthInt, frameSettingsModel.frameLengthBitsLengthInt);
    _addUintN(bytesIntList, framesCountInt, frameSettingsModel.framesCountBitsLengthInt);
    _addUintN(bytesIntList, protocolIdInt, frameSettingsModel.protocolIdBitsLengthInt);

    bytesIntList
      ..addAll(utf8.encode(sessionIdString))
      ..addAll(compositeChecksumUint8List)
      ..addAll(utf8.encode(dataString))
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
