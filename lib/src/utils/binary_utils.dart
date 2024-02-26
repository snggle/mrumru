class BinaryUtils {
  static List<String> splitBinary(String binary, int chunkSize) {
    RegExp regex = RegExp('.{1,$chunkSize}');
    List<String> chunks = regex.allMatches(binary).map((RegExpMatch match) => match.group(0)!).toList(growable: false);

    return chunks;
  }

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

    return chunks.map((List<String> chunk) => chunk.join('')).join('');
  }
}
