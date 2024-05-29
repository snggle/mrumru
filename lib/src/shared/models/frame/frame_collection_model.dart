import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';

class FrameCollectionModel extends Equatable {
  final List<FrameModel> frames;

  const FrameCollectionModel(this.frames);

  String get mergedBinaryFrames {
    return binaryFrames.join();
  }

  List<String> get binaryFrames {
    return frames.map((FrameModel frame) => frame.binaryString).toList();
  }

  String get mergedRawData {
    return frames.map((FrameModel e) => e.rawData).join();
  }

  @override
  List<Object?> get props => <Object>[frames];
}
