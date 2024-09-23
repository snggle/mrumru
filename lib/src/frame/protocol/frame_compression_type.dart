enum CompressionEnum {
  noCompression(0),
  zipFastest(1),
  zipDefault(2),
  zipMax(3),
  undefined(4);

  final int value;
  const CompressionEnum(this.value);

  static CompressionEnum fromValue(int value) {
    return CompressionEnum.values.firstWhere((CompressionEnum e) => e.value == value, orElse: () => CompressionEnum.undefined);
  }
}
