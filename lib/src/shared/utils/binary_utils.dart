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

  static List<String> splitBinary(String binary, int chunkSize) {
    RegExp regex = RegExp('.{1,$chunkSize}');
    List<String> chunks = regex.allMatches(binary).map((RegExpMatch match) => match.group(0)!).toList(growable: false);

    return chunks;
  }

  static List<int> binaryStringToByteList(String binaryText) {
    List<int> byteList = <int>[];
    for (int i = 0; i < binaryText.length; i += 8) {
      String byteString = binaryText.substring(i, i + 8);
      int byte = int.parse(byteString, radix: 2);
      byteList.add(byte);
    }
    return byteList;
  }
}
