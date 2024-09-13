enum EncodingEnum {
  defaultMethod(0),
  undefined(1);

  final int value;
  const EncodingEnum(this.value);

  static EncodingEnum fromValue(int value) {
    return EncodingEnum.values.firstWhere((EncodingEnum e) => e.value == value, orElse: () => EncodingEnum.undefined);
  }
}
