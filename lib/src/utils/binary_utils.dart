class BinaryUtils {
  static String convertAsciiToBinary(String asciiText) {
    return asciiText.codeUnits.map((int x) => x.toRadixString(2).padLeft(8, '0')).join();
  }

  static String convertBinaryToAscii(String binaryText) {
    String cleanedBinaryText = binaryText.trim();
    if (cleanedBinaryText.length % 8 != 0) {
      int extraBits = cleanedBinaryText.length % 8;
      cleanedBinaryText = cleanedBinaryText.substring(extraBits, cleanedBinaryText.length - extraBits);
    }

    List<String> binaryChunks = RegExp(r'\d{8}').allMatches(cleanedBinaryText).map((RegExpMatch m) => m.group(0)!).toList();

    List<int> asciiCodes = binaryChunks.map((String binaryChunk) => int.parse(binaryChunk, radix: 2)).toList();

    String asciiText = String.fromCharCodes(asciiCodes);

    return asciiText;
  }

  static String parseIntToPaddedBinary(int value, int digits) {
    return value.toRadixString(2).padLeft(digits, '0');
  }

  static String splitAndCombine(String binary, int bitsPerFrequency, int chunksCount) {
    List<String> parts = <String>[];
    for (int i = 0; i < binary.length; i += bitsPerFrequency) {
      parts.add(binary.substring(i, i + bitsPerFrequency));
    }

    List<List<String>> chunks = List<List<String>>.generate(chunksCount, (_) => <String>[]);

    int chunkIndex = 0;
    for(String part in parts) {
      chunks[chunkIndex].add(part);
      chunkIndex = (chunkIndex + 1) % chunksCount;
    }

    print('****************************************************');
    for (int i = 0; i < chunksCount; i++) {
      print('Chunk $i: ${chunks[i]}');
    }
    print('****************************************************');


    return chunks.map((List<String> chunk) => chunk.join('')).join('');
  }
}


// 00000000000000110100000101000010010000110100010011001011000000010000001101000101010001100100011101001000101111100000001000000011000000000100100101001010010010111111111100111100
// 000000000000001101000001010000100100001101000100110010110000000100000011010001010100011001000111010010001011111000000010000000110000000001001001010010100100101111111111