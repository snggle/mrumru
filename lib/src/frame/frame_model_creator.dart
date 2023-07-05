import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

class FrameModelCreator {
  List<String> createFrames(String rawData) {
    List<FrameModel> frames = <FrameModel>[];
    int frameNumber = 0;
    int numberOfAllFrames = (rawData.length / 30).ceil();
    int checksumOfAllData = _calculateChecksum(rawData);

    for (int i = 0; i < numberOfAllFrames; i++) {
      int startIndex = i * 30;
      int endIndex = ((i + 1) * 30 > rawData.length) ? rawData.length : (i + 1) * 30;
      String frameData = rawData.substring(startIndex, endIndex);

      FrameModel frameModel = FrameModel(
        frameNumber: frameNumber,
        lengthOfFrame: frameData.length,
        rawData: frameData,
        checksumOfFrame: _calculateChecksum(frameData),
        numberOfAllFrames: numberOfAllFrames,
        checksumOfAllData: checksumOfAllData,
      );

      frames.add(frameModel);
      frameNumber++;
    }

    List<String> binaryFrames = frames.map(_createBinaryFrameString).toList();

    return binaryFrames;
  }

  String _createBinaryFrameString(FrameModel frame) {
    String frameAsString = frame.frameNumber.toString().padLeft(4, '0') +
        frame.lengthOfFrame.toString().padLeft(8, '0') +
        frame.rawData +
        frame.checksumOfFrame.toString().padLeft(8, '0') +
        frame.numberOfAllFrames.toString().padLeft(8, '0') +
        frame.checksumOfAllData.toString().padLeft(8, '0');

    return BinaryUtils.convertAsciiToBinary(frameAsString);
  }

  int _calculateChecksum(String data) {
    List<int> codeUnits = data.codeUnits;
    return codeUnits.fold(0, (int previousValue, int element) => previousValue ^ element);
  }
}