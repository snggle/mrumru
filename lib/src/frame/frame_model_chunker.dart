import 'dart:math';

import 'package:mrumru/src/frame/frame_model_creator.dart';
import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/utils/binary_utils.dart';class FrameModelChunker {
  final int chunkSize;
  final FrameModelCreator _frameModelCreator = FrameModelCreator();

  FrameModelChunker({required this.chunkSize});

  List<FrameModel> chunk(String binaryString) {
    List<FrameModel> frames = <FrameModel>[];
    for (int i = 0; i < binaryString.length; i += chunkSize) {
      int end = (i+chunkSize < binaryString.length) ? i+chunkSize : binaryString.length;
      String chunk = binaryString.substring(i, end);

      int frameNumber = _parseBinaryString(chunk, 0, 4);
      int lengthOfFrame = _parseBinaryString(chunk, 4, 16);
      if (lengthOfFrame > chunk.length - 16) {
        lengthOfFrame = chunk.length - 16;
      }
      String rawData = BinaryUtils.convertBinaryToAscii(chunk.substring(16, 16 + lengthOfFrame));
      int checksumOfFrame = _parseBinaryString(chunk, 16 + lengthOfFrame, min(16 + lengthOfFrame + 8, chunk.length));
      int numberOfAllFrames = _parseBinaryString(chunk, min(16 + lengthOfFrame + 8, chunk.length), min(16 + lengthOfFrame + 12, chunk.length));
      int checksumOfAllData = _parseBinaryString(chunk, min(16 + lengthOfFrame + 12, chunk.length), min(16 + lengthOfFrame + 16, chunk.length));

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

  int _parseBinaryString(String binaryString, int startIndex, int endIndex) {
    if (startIndex < binaryString.length && endIndex <= binaryString.length) {
      return int.parse(binaryString.substring(startIndex, endIndex), radix: 2);
    }
    return 0;
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
