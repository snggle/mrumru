import 'package:mrumru/src/models/frame_model.dart';
import 'package:mrumru/src/utils/binary_utils.dart';

class FrameModelCreator {
  late String _rawData;
  late List<FrameModel> _frames;
  late int _numberOfAllFrames;
  late int _checksumOfAllData;

  List<String> createFrames(String rawData) {
    _initializeFields(rawData);

    for (int i = 0; i < _numberOfAllFrames; i++) {
      _createFrameModelForIndex(i);
    }

    return _convertFrameModelsToBinary();
  }

  void _initializeFields(String rawData) {
    _rawData = rawData;
    _frames = <FrameModel>[];
    _numberOfAllFrames = (_rawData.length / 30).ceil();
    _checksumOfAllData = _calculateChecksum(_rawData);
  }

  void _createFrameModelForIndex(int index) {
    String frameData = _getFrameDataForIndex(index);

    FrameModel frameModel = FrameModel(
      frameNumber: index,
      lengthOfFrame: frameData.length,
      rawData: frameData,
      checksumOfFrame: _calculateChecksum(frameData),
      numberOfAllFrames: _numberOfAllFrames,
      checksumOfAllData: _checksumOfAllData,
    );

    _frames.add(frameModel);
  }

  String _getFrameDataForIndex(int index) {
    int startIndex = index * 30;
    int endIndex = ((index + 1) * 30 > _rawData.length) ? _rawData.length : (index + 1) * 30;
    return _rawData.substring(startIndex, endIndex);
  }

  List<String> _convertFrameModelsToBinary() {
    return _frames.map(_createBinaryFrameString).toList();
  }

  String _createBinaryFrameString(FrameModel frame) {
    String frameNumberBinary = frame.frameNumber.toRadixString(2).padLeft(4, '0');
    String checksumOfFrameASCII = String.fromCharCode(frame.checksumOfFrame);
    String numberOfAllFramesASCII = String.fromCharCode(frame.numberOfAllFrames);
    String checksumOfAllDataASCII = String.fromCharCode(frame.checksumOfAllData);

    String frameAsString = frameNumberBinary +
        frame.rawData +
        frame.lengthOfFrame.toString().padLeft(8, '0') +
        checksumOfFrameASCII +
        numberOfAllFramesASCII +
        checksumOfAllDataASCII;

    return BinaryUtils.convertAsciiToBinary(frameAsString);
  }

  int _calculateChecksum(String data) {
    List<int> codeUnits = data.codeUnits;
    return codeUnits.fold(0, (int previousValue, int element) => previousValue ^ element);
  }
}
