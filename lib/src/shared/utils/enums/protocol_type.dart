enum ProtocolType {
  /// Raw data transfer
  rawDataTransfer(0),

  /// Calibration test
  calibrationTest(1),

  /// Simple handshake (sharing of calibration data)
  simpleHandshake(2),

  /// End-to-end encryption Handshake (sharing of calibration data + DHKE)
  endToEndEncryption(3),

  /// Data partially received (recalibration)
  dataPartiallyReceived(4),

  /// All data received (acknowledgement)
  allDataReceived(5),

  /// Failed to receive data or canceled operation
  failedToReceiveData(6),

  /// Undefined
  undefined(7);

  final int value;

  const ProtocolType(this.value);

  static ProtocolType fromValue(int value) {
    return ProtocolType.values.firstWhere(
      (ProtocolType e) => e.value == value,
      orElse: () => ProtocolType.undefined,
    );
  }
}
