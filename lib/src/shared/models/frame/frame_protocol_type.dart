/// Enum class for frame protocol types.
enum FrameProtocolType {
  /// Frame protocol types
  rawDataTransfer(0),
  calibrationTest(1),
  simpleHandshake(2),
  endToEndEncryption(3),
  dataPartiallyReceived(4),
  allDataReceived(5),
  failedToReceiveData(6),
  undefined(7);

  /// The value of the frame protocol type.
  final int value;

  /// Creates a instance of [FrameProtocolType].
  const FrameProtocolType(this.value);

  /// Returns a instance of [FrameProtocolType] from the given [value].
  static FrameProtocolType fromValue(int value) {
    return FrameProtocolType.values.firstWhere(
      (FrameProtocolType e) => e.value == value,
      orElse: () => FrameProtocolType.undefined,
    );
  }
}
