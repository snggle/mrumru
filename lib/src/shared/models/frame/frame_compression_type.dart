/// Enum for frame compression type
enum FrameCompressionType {
  /// Frame compression types
  noCompression(0),
  zipFastest(1),
  zipDefault(2),
  zipMax(3),
  undefined(4);

  /// The value of the frame compression type.
  final int value;

  /// Creates a instance of [FrameCompressionType].
  const FrameCompressionType(this.value);

  /// Returns a instance of [FrameCompressionType] from the given [value].
  static FrameCompressionType fromValue(int value) {
    return FrameCompressionType.values.firstWhere(
      (FrameCompressionType e) => e.value == value,
      orElse: () => FrameCompressionType.undefined,
    );
  }
}
