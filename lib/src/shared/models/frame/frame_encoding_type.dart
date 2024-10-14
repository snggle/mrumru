/// Enum class for frame encoding types.
enum FrameEncodingType {
  /// Frame encoding types
  defaultMethod(0),
  undefined(1);

  /// The value of the frame encoding type.
  final int value;

  /// Creates a instance of [FrameEncodingType].
  const FrameEncodingType(this.value);

  /// Returns a instance of [FrameEncodingType] from the given [value].
  static FrameEncodingType fromValue(int value) {
    return FrameEncodingType.values.firstWhere(
      (FrameEncodingType e) => e.value == value,
      orElse: () => FrameEncodingType.undefined,
    );
  }
}
