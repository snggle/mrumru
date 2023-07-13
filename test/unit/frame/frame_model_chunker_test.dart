import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/frame/frame_model_chunker.dart';
import 'package:mrumru/src/frame/frame_model_creator.dart';
import 'package:mrumru/src/models/frame_model.dart';

void main() {
  group('FrameModelChunker', () {
    late FrameModelCreator creator;
    late FrameModelChunker chunker;
    late String rawData;

    setUp(() {
      creator = FrameModelCreator();
      chunker = FrameModelChunker(chunkSize: 64);
      rawData = 'This is a test binary string. We use it to test the chunking and concatenation functionality.';
    });

    test('chunk method should split the data into chunks', () {
      String binaryString = creator.createFrames(rawData).join();
      List<FrameModel> chunks = chunker.chunk(binaryString);

      expect(chunks.length, equals(rawData.length / 30));
      for (FrameModel chunk in chunks) {
        expect(chunk.rawData, isNotNull);
      }
    });

    test('concatenateRawData method should join the chunks back together', () {
      String binaryString = creator.createFrames(rawData).join();
      List<FrameModel> chunks = chunker.chunk(binaryString);

      String concatenatedData = chunker.concatenateRawData(chunks);

      expect(concatenatedData, equals(rawData));
    });

    test('calculateChecksumForConcatenatedData method should return correct checksum', () {
      String binaryString = creator.createFrames(rawData).join();
      List<FrameModel> chunks = chunker.chunk(binaryString);

      int calculatedChecksum = chunker.calculateChecksumForConcatenatedData(chunks);
      int expectedChecksum = creator.calculateChecksum(rawData);

      expect(calculatedChecksum, equals(expectedChecksum));
    });
  });
}
