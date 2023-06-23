import 'dart:typed_data';

class FrameModel {
  late int frameNumber;
  late int lengthOfFrame;
  late int numberOfAllFrames;
  late int checksumOfAllData;
  late Uint8List rawData;
  late int checksumOfFrame;

  FrameModel({
    required this.frameNumber,
    required this.lengthOfFrame,
    required this.numberOfAllFrames,
    required this.checksumOfAllData,
    required this.rawData,
    required this.checksumOfFrame,
  });

  FrameModel.empty() {
    frameNumber = 0;
    lengthOfFrame = 0;
    numberOfAllFrames = 0;
    checksumOfAllData = 0;
    rawData = Uint8List(0);
    checksumOfFrame = 0;
  }

  void fillData(Uint8List data, int givenFrameNumber, int totalFrames, int checksumOfAllData) {
    rawData = data;
    frameNumber = givenFrameNumber;
    numberOfAllFrames = totalFrames;
    this.checksumOfAllData = checksumOfAllData;
    checksumOfFrame = _calculateChecksum(data);
    lengthOfFrame = _calculateFrameLength();
  }

  int _calculateFrameLength() {
    return rawData.length + frameNumber.bitLength + numberOfAllFrames.bitLength + checksumOfFrame.bitLength + checksumOfAllData.bitLength;
  }

  int _calculateChecksum(Uint8List data) {
    return data.fold(0, (int previousValue, int element) => previousValue ^ element);
  }

  int calculateChecksumOfEntireFrame() {
    int total = frameNumber + lengthOfFrame + numberOfAllFrames + checksumOfAllData + checksumOfFrame;
    return total ^ _calculateChecksum(rawData);
  }
}
