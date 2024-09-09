

enum DuplexFlag {
  single,
  requestResponse,
  noData,
  unknown, none,
}

class DuplexUtils {
  static String duplexFlagToBinaryString(DuplexFlag flag) {
    switch (flag) {
      case DuplexFlag.single:
        return '0000'; // Single message, no response needed
      case DuplexFlag.requestResponse:
        return '0001'; // Message requires a response (default)
      case DuplexFlag.noData:
        return '0010'; // Message without data
      case DuplexFlag.unknown:
      default:
        return '1111'; // Unknown
    }
  }

  static DuplexFlag parseDuplexFlagBinary(String duplexFlagBinary) {
    switch (duplexFlagBinary) {
      case '0000':
        return DuplexFlag.single;
      case '0001':
        return DuplexFlag.requestResponse;
      case '0010':
        return DuplexFlag.noData;
      case '1111':
      default:
        return DuplexFlag.unknown;
    }
  }
}
