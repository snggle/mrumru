import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';

/// A class that represents a FrameCollectionModel.
class FrameCollectionModel extends Equatable {
  final List<ABaseFrame> frames;

  /// Creates a instance of [FrameCollectionModel] with the given [frames].
  const FrameCollectionModel(this.frames);

  /// Merges the binary representations of all frames into a single binary string.
  String get mergedBinaryFrames {
    return frames.map((ABaseFrame frame) => frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(BigIntUtils.bitsInByte, '0')).join()).join();
  }

  /// Converts each frame into its binary representation.
  List<String> get binaryFrames {
    return frames.map((ABaseFrame frame) => frame.toBytes().map((int byte) => byte.toRadixString(2).padLeft(BigIntUtils.bitsInByte, '0')).join()).toList();
  }

  /// Merges the data bytes of all data frames into a single byte array.
  Uint8List get mergedDataBytes {
    return Uint8List.fromList(
      frames.whereType<DataFrame>().map((DataFrame frame) => frame.data.bytes).expand((Uint8List bytes) => bytes).toList(),
    );
  }

  @override
  List<Object?> get props => <Object>[frames];
}
