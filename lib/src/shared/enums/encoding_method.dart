enum EncodingMethod {
  /// Default method
  defaultMethod(0),

  /// Undefined
  undefined(1);

  final int value;

  const EncodingMethod(this.value);

  static EncodingMethod fromValue(int value) {
    return EncodingMethod.values.firstWhere(
      (EncodingMethod e) => e.value == value,
      orElse: () => EncodingMethod.undefined,
    );
  }
}
