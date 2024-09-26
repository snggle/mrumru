import 'package:equatable/equatable.dart';
import 'package:mrumru/src/frame/protocol/data_frame.dart';
import 'package:mrumru/src/frame/protocol/metadata_frame.dart';
import 'package:mrumru/src/frame/protocol/a_base_frame.dart';

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
  String get mergedRawData {
    return frames.map((ABaseFrame frame) {
      if (frame is MetadataFrame) {
        return frame.dataString;
      } else if (frame is DataFrame) {
        return frame.dataString;
      } else {
        return '';
      }
    }).join();
  }

  @override
  List<Object?> get props => <Object>[frames];
}
