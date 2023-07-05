import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/frame/frame_model_creator.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

void main() {
  group('Test of FrameModelCreator.createFrames()', () {
    test('Should return list of created frames from raw data', () {
      // Arrange
      String actualRawData = 'b';
      FrameModelCreator actualFrameModelCreator = FrameModelCreator();

      // Act
      List<String> actualFrames = actualFrameModelCreator.createFrames(actualRawData);

      // Assert
      for(String frame in actualFrames){
        print('${frame.toString()}      ${BinaryUtils.convertBinaryToAscii(frame)}');
      }
    });
  });
}
