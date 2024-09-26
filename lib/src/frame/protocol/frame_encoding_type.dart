enum FrameEncodingType {
  defaultMethod(0),
  undefined(1);

  final int value;

  const FrameEncodingType(this.value);

  static FrameEncodingType fromValue(int value) {
    return FrameEncodingType.values.firstWhere((FrameEncodingType e) => e.value == value, orElse: () => FrameEncodingType.undefined);
  }
}
