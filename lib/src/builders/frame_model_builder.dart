import 'dart:typed_data';

import 'package:mrumru/src/models/frame_model.dart';

class FrameModelBuilder {
  int? frameNumber;
  int? lengthOfFrame;
  int? numberOfAllFrames;
  int? checksumOfAllData;
  Uint8List? rawData;
  int? checksumOfFrame;

  FrameModelBuilder();

  void setRawData(Uint8List data) {
    rawData = data;
  }

  void setFrameNumber(int number) {
    frameNumber = number;
  }

  void setNumberOfAllFrames(int total) {
    numberOfAllFrames = total;
  }

  void setChecksumOfAllData(int checksum) {
    checksumOfAllData = checksum;
  }

  FrameModel build() {
    final Uint8List? rawData = this.rawData;
    final int? frameNumber = this.frameNumber;
    final int? numberOfAllFrames = this.numberOfAllFrames;
    final int? checksumOfAllData = this.checksumOfAllData;

    if (frameNumber == null ||
        numberOfAllFrames == null ||
        checksumOfAllData == null ||
        rawData == null) {
      throw Exception('Missing required data for FrameModel');
    }
    FrameModel frameModel = FrameModel(frameNumber: frameNumber, lengthOfFrame: 1, numberOfAllFrames: numberOfAllFrames, checksumOfAllData: checksumOfAllData, rawData: rawData, checksumOfFrame: 1);
    return frameModel;
  }
}
