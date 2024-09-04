import 'package:equatable/equatable.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/utils/duplex_utils.dart';

class DuplexFrame extends Equatable {
  final FrameModel frame;
  final DuplexMode duplexMode;
  final DuplexFlag duplexFlag;

  const DuplexFrame({
    required this.frame,
    required this.duplexMode,
    required this.duplexFlag,
  });

  factory DuplexFrame.fromBinaryString(String binaryString) {
    final String frameBinaryString = binaryString.substring(0, binaryString.length - 8);
    final String duplexModeBinary = binaryString.substring(binaryString.length - 8, binaryString.length - 4);
    final String duplexFlagBinary = binaryString.substring(binaryString.length - 4);

    final FrameModel frame = FrameModel.fromBinaryString(frameBinaryString);
    final DuplexMode duplexMode = DuplexUtils.parseDuplexModeBinary(duplexModeBinary);
    final DuplexFlag duplexFlag = DuplexUtils.parseDuplexFlagBinary(duplexFlagBinary);

    return DuplexFrame(frame: frame, duplexMode: duplexMode, duplexFlag: duplexFlag);
  }

  factory DuplexFrame.fromFrameModel(FrameModel frameModel, DuplexMode mode, DuplexFlag flag) {
    return DuplexFrame(
      frame: frameModel,
      duplexMode: mode,
      duplexFlag: flag,
    );
  }

  String get binaryString {
    return frame.binaryString + DuplexUtils.duplexModeToBinaryString(duplexMode) + DuplexUtils.duplexFlagToBinaryString(duplexFlag);
  }

  @override
  List<Object?> get props => <Object>[frame, duplexMode, duplexFlag];
}
