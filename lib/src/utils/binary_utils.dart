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
}
