enum FrameCompressionType {
  noCompression(0),
  zipFastest(1),
  zipDefault(2),
  zipMax(3),
  undefined(4);

  final int value;

  const FrameCompressionType(this.value);

  static FrameCompressionType fromValue(int value) {
    return FrameCompressionType.values.firstWhere((FrameCompressionType e) => e.value == value, orElse: () => FrameCompressionType.undefined);
  }
}
