import 'dart:typed_data';

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

  static Uint8List binaryStringToByteList(String binaryText) {
    Uint8List byteList = Uint8List((binaryText.length / 8).ceil());
    for (int i = 0; i < binaryText.length; i += 8) {
      String byteString = binaryText.substring(i, i + 8);
      int byte = int.parse(byteString, radix: 2);
      byteList[i ~/ 8] = byte;
    }
    return byteList;
  }

  static Uint8List intToBytes(int value, int byteSize) {
    ByteData data = ByteData(byteSize);
    if (byteSize == 2) {
      data.setUint16(0, value);
    } else if (byteSize == 4) {
      data.setUint32(0, value);
    }
    return data.buffer.asUint8List();
  }

  static bool compareUint8Lists(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  static String convertBytesToBinary(Uint8List bytes) {
    return bytes.map((int x) => x.toRadixString(2).padLeft(8, '0')).join();
  }

  static Uint8List convertBinaryToBytes(String binaryText) {
    return binaryStringToByteList(binaryText);
  }

  static Uint8List stringToBytes(String input, int expectedLength) {
    return Uint8List.fromList(input.codeUnits).sublist(0, expectedLength);
  }

}
