import 'dart:typed_data';

class FrameModel {
  int frameNumber;
  int lengthOfFrame;
  int numberOfAllFrames;
  int checksumOfAllData;
  Uint8List rawData;
  int checksumOfFrame;

  FrameModel({
    required this.frameNumber,
    required this.lengthOfFrame,
    required this.numberOfAllFrames,
    required this.checksumOfAllData,
    required this.rawData,
    required this.checksumOfFrame,
  });

  FrameModel.empty()
      : frameNumber = 0,
        lengthOfFrame = 0,
        numberOfAllFrames = 0,
        checksumOfAllData = 0,
        rawData = Uint8List(0),
        checksumOfFrame = 0;

  void fillData(Uint8List data, int givenFrameNumber, int totalFrames, int protocolID, int sessionID, int checksumOfAllData) {
    rawData = data;
    frameNumber = frameNumber;
    numberOfAllFrames = totalFrames;
    this.checksumOfAllData = checksumOfAllData;
    checksumOfFrame = calculateChecksum(data);
    lengthOfFrame = data.length + frameNumber.bitLength + numberOfAllFrames.bitLength + checksumOfFrame.bitLength + checksumOfFrame.bitLength;
  }

  int calculateChecksum(Uint8List data) {
    int checksum = 0;
    for (int byte in data) {
      checksum = checksum ^ byte;
    }
    return checksum;
  }
}
