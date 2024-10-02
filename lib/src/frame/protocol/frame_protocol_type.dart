enum FrameProtocolType {
  rawDataTransfer(0),
  calibrationTest(1),
  simpleHandshake(2),
  endToEndEncryption(3),
  dataPartiallyReceived(4),
  allDataReceived(5),
  failedToReceiveData(6),
  undefined(7);

  final int value;

  const FrameProtocolType(this.value);

  static FrameProtocolType fromValue(int value) {
    return FrameProtocolType.values.firstWhere(
          (FrameProtocolType e) => e.value == value,
      orElse: () => FrameProtocolType.undefined,
    );
  }
}