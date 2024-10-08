import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';

class FrameCollectionModel extends Equatable {
  final List<AFrameBase> frames;

  const FrameCollectionModel(this.frames);

  /// Merges the binary representations of all frames into a single binary string.
  String get mergedBinaryFrames {
    return frames.map((AFrameBase frame) => frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join()).join();
  }

  /// Converts each frame into its binary representation.
  List<String> get binaryFrames {
    return frames.map((AFrameBase frame) => frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(8, '0')).join()).toList();
  }

  /// Merges the raw data of all frames into a single string.
  String get mergedRawData {
    return String.fromCharCodes(mergedRawDataBytes);
  }

  Uint8List get mergedRawDataBytes {
    return Uint8List.fromList(
      frames.whereType<DataFrame>().map((DataFrame frame) => frame.data.bytes).expand((Uint8List bytes) => bytes).toList(),
    );
  }

  @override
  List<Object?> get props => <Object>[frames];
}
