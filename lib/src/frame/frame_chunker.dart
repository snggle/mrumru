import 'package:mrumru/src/frame/frame_model_creator.dart';
import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

class FrameModelChunker {
  final int chunkSize;
  final FrameModelCreator _frameModelCreator = FrameModelCreator();

  FrameModelChunker({required this.chunkSize});

  List<FrameModel> chunk(String binaryString) {
    List<FrameModel> frames = <FrameModel>[];
    for (int i = 0; i < binaryString.length; i += chunkSize) {
      int end = (i+chunkSize < binaryString.length) ? i+chunkSize : binaryString.length;
      String chunk = binaryString.substring(i, end);

      int frameNumber = int.parse(chunk.substring(0, 4), radix: 2);
      int lengthOfFrame = int.parse(chunk.substring(4, 16), radix: 2);
      String rawData = BinaryUtils.convertBinaryToAscii(chunk.substring(16, 16 + lengthOfFrame));
      int checksumOfFrame = int.parse(chunk.substring(16 + lengthOfFrame, 16 + lengthOfFrame + 8), radix: 2);
      int numberOfAllFrames = int.parse(chunk.substring(16 + lengthOfFrame + 8, 16 + lengthOfFrame + 12), radix: 2);
      int checksumOfAllData = int.parse(chunk.substring(16 + lengthOfFrame + 12, 16 + lengthOfFrame + 16), radix: 2);

      if (checksumOfFrame == _frameModelCreator.calculateChecksum(rawData)) {
        frames.add(FrameModel(
            frameNumber: frameNumber,
            lengthOfFrame: lengthOfFrame,
            numberOfAllFrames: numberOfAllFrames,
            checksumOfAllData: checksumOfAllData,
            rawData: rawData,
            checksumOfFrame: checksumOfFrame
        ));
      }
    }
    return frames;
  }

  String concatenateRawData(List<FrameModel> frames) {
    StringBuffer concatenatedRawData = StringBuffer();
    for (FrameModel frame in frames) {
      concatenatedRawData.write(frame.rawData);
    }
    return concatenatedRawData.toString();
  }

  String getFrameRawData(FrameModel frame) {
    return frame.rawData.substring(0, frame.lengthOfFrame);
  }

  int calculateChecksumForConcatenatedData(List<FrameModel> frames) {
    String concatenatedData = concatenateRawData(frames);
    return _frameModelCreator.calculateChecksum(concatenatedData);
  }
}
