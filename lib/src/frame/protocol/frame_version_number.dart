enum FrameVersionNumber {
  reserved(0),
  firstDefault(1),
  undefined(2);

  final int value;

  const FrameVersionNumber(this.value);

  static FrameVersionNumber fromValue(int value) {
    return FrameVersionNumber.values.firstWhere(
          (FrameVersionNumber e) => e.value == value,
      orElse: () => FrameVersionNumber.undefined,
    );
  }
}