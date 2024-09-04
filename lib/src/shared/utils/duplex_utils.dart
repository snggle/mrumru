enum DuplexMode {
  none,
  halfDuplex,
  fullDuplex,
  unknown,
}

enum DuplexFlag {
  response,
  calibrate,
  listening,
  transmitting,
  unknown, none,
}

class DuplexUtils {
  static String duplexModeToBinaryString(DuplexMode mode) {
    switch (mode) {
      case DuplexMode.none:
        return '0000'; // None
      case DuplexMode.halfDuplex:
        return '0001'; // Half Duplex
      case DuplexMode.fullDuplex:
        return '0010'; // Full Duplex
      case DuplexMode.unknown:
      default:
        return '1111'; // Unknown
    }
  }

  static String duplexFlagToBinaryString(DuplexFlag flag) {
    switch (flag) {
      case DuplexFlag.response:
        return '0000'; // Response
      case DuplexFlag.calibrate:
        return '0001'; // Calibrate
      case DuplexFlag.listening:
        return '0010'; // Listening
      case DuplexFlag.transmitting:
        return '0011'; // Transmitting
      case DuplexFlag.unknown:
      default:
        return '1111'; // Unknown
    }
  }

  static DuplexMode parseDuplexModeBinary(String duplexModeBinary) {
    switch (duplexModeBinary) {
      case '0000':
        return DuplexMode.none;
      case '0001':
        return DuplexMode.halfDuplex;
      case '0010':
        return DuplexMode.fullDuplex;
      case '1111':
      default:
        return DuplexMode.unknown;
    }
  }

  static DuplexFlag parseDuplexFlagBinary(String duplexFlagBinary) {
    switch (duplexFlagBinary) {
      case '0000':
        return DuplexFlag.response;
      case '0001':
        return DuplexFlag.calibrate;
      case '0010':
        return DuplexFlag.listening;
      case '0011':
        return DuplexFlag.transmitting;
      case '1111':
      default:
        return DuplexFlag.unknown;
    }
  }
}