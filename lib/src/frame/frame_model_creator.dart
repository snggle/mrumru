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
    _checksumOfAllData = calculateChecksum(_rawData);
  }

  void _createFrameModelForIndex(int index) {
    String frameData = _getFrameDataForIndex(index);

    FrameModel frameModel = FrameModel(
      frameNumber: index,
      lengthOfFrame: frameData.length,
      rawData: frameData,
      checksumOfFrame: calculateChecksum(frameData),
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
    String rawDataBinary = BinaryUtils.convertAsciiToBinary(frame.rawData);
    String lengthOfFrameBinary = frame.lengthOfFrame.toRadixString(2).padLeft(8, '0');
    String checksumOfFrameBinary = frame.checksumOfFrame.toRadixString(2).padLeft(8, '0');
    String numberOfAllFramesBinary = frame.numberOfAllFrames.toRadixString(2).padLeft(4, '0');
    String checksumOfAllDataBinary = frame.checksumOfAllData.toRadixString(2).padLeft(8, '0');

    String frameAsString = frameNumberBinary + lengthOfFrameBinary + rawDataBinary + checksumOfFrameBinary + numberOfAllFramesBinary + checksumOfAllDataBinary;

    return frameAsString;
  }

  int calculateChecksum(String data) {
    List<int> codeUnits = data.codeUnits;
    return codeUnits.fold(0, (int previousValue, int element) => previousValue ^ element);
  }
}
