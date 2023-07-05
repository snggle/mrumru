class FrameModel {
  int frameNumber;
  String rawData;
  int lengthOfFrame;
  int numberOfAllFrames;
  int checksumOfAllData;
  int checksumOfFrame;

  FrameModel({
    required this.frameNumber,
    required this.lengthOfFrame,
    required this.numberOfAllFrames,
    required this.checksumOfAllData,
    required this.rawData,
    required this.checksumOfFrame,
  });

  void fillData(String data, int givenFrameNumber, int totalFrames, int checksumOfAllData) {
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

  int _calculateChecksum(String data) {
    List<int> codeUnits = data.codeUnits;
    return codeUnits.fold(0, (int previousValue, int element) => previousValue ^ element);
  }

  int calculateChecksumOfEntireFrame() {
    int total = frameNumber + lengthOfFrame + numberOfAllFrames + checksumOfAllData + checksumOfFrame;
    return total ^ _calculateChecksum(rawData);
  }

  @override
  String toString() {
    return '${frameNumber}${rawData}${lengthOfFrame}${numberOfAllFrames}${checksumOfAllData}${checksumOfFrame}';
  }
}
