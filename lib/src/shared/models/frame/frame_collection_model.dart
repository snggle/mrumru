import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class FrameCollectionModel extends Equatable {
  final List<ABaseFrame> frames;

  const FrameCollectionModel(this.frames);

  /// Merges the binary representations of all frames into a single binary string.
  String get mergedBinaryFrames {
    return frames.map((ABaseFrame frame) => frame.binaryString).join();
  }

  /// Converts each frame into its binary representation.
  List<String> get binaryFrames {
    return frames.map((ABaseFrame frame) => frame.binaryString).toList();
  }

  /// Merges the raw data of all frames into a single string.
  String get mergedDataString {
    return frames.map((ABaseFrame frame) => frame.binaryString).join();
  }

  @override
  List<Object?> get props => <Object>[frames];
}
