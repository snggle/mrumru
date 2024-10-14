/// Enum for frame version numbers.
enum FrameVersionNumber {
  /// Frame version numbers
  reserved(0),
  firstDefault(1),
  undefined(2);

  /// The value of the frame version number.
  final int value;

  /// Creates a instance of [FrameVersionNumber].
  const FrameVersionNumber(this.value);

  /// Returns a instance of [FrameVersionNumber] from the given [value].
  static FrameVersionNumber fromValue(int value) {
    return FrameVersionNumber.values.firstWhere(
      (FrameVersionNumber e) => e.value == value,
      orElse: () => FrameVersionNumber.undefined,
    );
  }
}
