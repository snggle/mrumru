class FskDecoder {
  final int baseFrequency;
  final int frequencyStep;
  final int bitsPerFrequency;

  FskDecoder({
    required this.baseFrequency,
    required this.frequencyStep,
    required this.bitsPerFrequency,
  });

  String decodeFrequenciesToBinary(List<int> samples) {
    StringBuffer decodedBinaryData = StringBuffer();

    for (int frequency in samples) {
      int chunk = (frequency - baseFrequency) ~/ frequencyStep;
      String chunkBits = chunk.toRadixString(2).padLeft(bitsPerFrequency, '0');
      decodedBinaryData.write(chunkBits);
    }

    return decodedBinaryData.toString();
  }
}
