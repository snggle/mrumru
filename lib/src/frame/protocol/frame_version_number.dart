enum VersionNumberEnum {
  reserved(0),
  firstDefault(1),
  undefined(2);

  final int value;

  const VersionNumberEnum(this.value);

  static VersionNumberEnum fromValue(int value) {
    return VersionNumberEnum.values.firstWhere((VersionNumberEnum e) => e.value == value, orElse: () => VersionNumberEnum.undefined);
  }
}
