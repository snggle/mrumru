class FskEncoder {
  final int baseFrequency;
  final int frequencyStep;
  final int bitsPerFrequency;

  FskEncoder({
    required this.baseFrequency,
    required this.frequencyStep,
    required this.bitsPerFrequency,
  });

  List<int> encodeBinaryDataToFrequencies(String binaryData) {
    List<int> encodedFrequencies = <int>[];

    for (int i = 0; i < binaryData.length; i += bitsPerFrequency) {
      late String chunkBits;
      if (i + bitsPerFrequency < binaryData.length) {
        chunkBits = binaryData.substring(i, i + bitsPerFrequency);
      } else {
        chunkBits = binaryData.substring(i, binaryData.length);
        chunkBits = chunkBits.padRight(bitsPerFrequency, '0');
      }

      int frequency = baseFrequency + int.parse(chunkBits, radix: 2) * frequencyStep;
      encodedFrequencies.add(frequency);
    }
    return encodedFrequencies;
  }
}
