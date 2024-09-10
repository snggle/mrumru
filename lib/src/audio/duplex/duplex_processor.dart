import 'package:mrumru/mrumru.dart';

/// Processes duplex communication based on the flag.
class DuplexProcessor {
  /// Handles a message with the `single` flag, which does not require a response.
  Future<void> handleSingleMessage(String data) async {}

  /// Handles a message with the `requestResponse` flag, which requires a response.
  Future<void> handleRequestResponseMessage(String data, DuplexController controller) async {
    if (data == 'ping') {
      await controller.send('pong', DuplexFlag.requestResponse);
    } else {
      await controller.send(data, DuplexFlag.requestResponse);
    }
  }

  /// Handles a message with the `noData` flag, indicating a control signal with no data.
  Future<void> handleNoDataMessage() async {}

  /// Checks for missing data and emits a message with the indices of missing frames if needed.
  /// Checks for missing data and returns a string with the indices of missing frames.
  String handleMissingData(FrameCollectionModel frameCollectionModel) {
    List<FrameModel> frames = frameCollectionModel.frames;

    int expectedFrameCount = frames.first.framesCount;
    List<int> missingFrames = <int>[];

    for (int i = 0; i < expectedFrameCount; i++) {
      bool frameExists = frames.any((FrameModel frame) => frame.frameIndex == i);
      if (!frameExists) {
        missingFrames.add(i);
      }
    }

    if (missingFrames.isEmpty) {
      return '';
    }

    return missingFrames.join(',');
  }

  /// Handles unknown or unsupported flags.
  Future<void> handleUnknownFlag() async {}
}
