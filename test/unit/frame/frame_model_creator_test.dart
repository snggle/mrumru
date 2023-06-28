import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_model_creator.dart';

void main() {
  group('Test of FrameModelCreator.createFrames()', () {
    test('Should return list of created frames from raw data', () {
      // Arrange
      String actualRawData = 'asddddddddddddddddddddddddddddddddddddddddddddddddddddddfjkl';
      FrameModelCreator actualFrameModelCreator = FrameModelCreator();

      // Act
      List<FrameModel> actualFrames = actualFrameModelCreator.createFrames(actualRawData);

      // Assert
      // TODO(a): Assert after correcting creation of the frame
      for(FrameModel frame in actualFrames){
        print('frame: [${frame.frameNumber}|${frame.rawData}|${frame.numberOfAllFrames}|${frame.checksumOfFrame}|${frame.checksumOfAllData}|${frame.lengthOfFrame}|');
      }
    });
  });
}
