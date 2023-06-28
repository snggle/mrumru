import 'package:mrumru/src/models/frame_model.dart';
// TODO(a): Need to think about slicing frame and calculating checksums
class FrameModelCreator {
  List<FrameModel> createFrames(String rawData) {
    List<FrameModel> frames = <FrameModel>[];
    int frameNumber = 0;
    int numberOfAllFrames = (rawData.length / 240).ceil();

    for (int i = 0; i < numberOfAllFrames; i++) {
      int startIndex = i * 240;
      int endIndex = (i + 1) * 240;
      String frameData = rawData.substring(startIndex, endIndex < rawData.length ? endIndex : rawData.length);
      int checksumOfFrame = _calculateChecksum(frameData);
      int lengthOfFrame = _calculateFrameLength(frameData, frameNumber, numberOfAllFrames, checksumOfFrame);

      FrameModel frameModel = FrameModel(
        frameNumber: frameNumber,
        lengthOfFrame: lengthOfFrame,
        numberOfAllFrames: numberOfAllFrames,
        checksumOfAllData: _calculateChecksum(rawData),
        rawData: frameData,
        checksumOfFrame: checksumOfFrame,
      );

      frames.add(frameModel);
      frameNumber++;
    }

    return frames;
  }

  int _calculateFrameLength(String frameData, int frameNumber, int numberOfAllFrames, int checksumOfFrame) {
    return frameData.length + frameNumber.bitLength + numberOfAllFrames.bitLength + checksumOfFrame.bitLength;
  }

  int _calculateChecksum(String data) {
    List<int> codeUnits = data.codeUnits;
    return codeUnits.fold(0, (int previousValue, int element) => previousValue ^ element);
  }
}
