enum CompressionMethod {
  /// No compression
  noCompression(0),

  /// ZIP (Fastest compression - level 1)
  zipFastest(1),

  /// ZIP (Default compression - level 6)
  zipDefault(2),

  /// ZIP (Maximum compression - level 9)
  zipMax(3),

  /// Undefined
  undefined(4);

  final int value;

  const CompressionMethod(this.value);

  static CompressionMethod fromValue(int value) {
    return CompressionMethod.values.firstWhere(
      (CompressionMethod e) => e.value == value,
      orElse: () => CompressionMethod.undefined,
    );
  }
}
