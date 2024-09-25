enum ProtocolTypeEnum {
  rawDataTransfer(0),
  calibrationTest(1),
  simpleHandshake(2),
  endToEndEncryption(3),
  dataPartiallyReceived(4),
  allDataReceived(5),
  failedToReceiveData(6),
  undefined(7);

  final int value;

  const ProtocolTypeEnum(this.value);

  static ProtocolTypeEnum fromValue(int value) {
    return ProtocolTypeEnum.values.firstWhere((ProtocolTypeEnum e) => e.value == value, orElse: () => ProtocolTypeEnum.undefined);
  }
}
