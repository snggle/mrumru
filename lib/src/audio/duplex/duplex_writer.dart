import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';
import 'package:mrumru/src/frame/protocol/uint_32_frame_protocol_id.dart';


/// Class to create protocol ID for a frame, either with default values or specified by the user.
class DuplexWriter {
  /// Creates a protocol ID with default values.
  Uint32FrameProtocolID createDefaultProtocolID() {
    return Uint32FrameProtocolID.fromValues(
      frameCompressionType: FrameCompressionType.noCompression,
      frameEncodingType: FrameEncodingType.defaultMethod,
      frameProtocolType: FrameProtocolType.rawDataTransfer,
      frameVersionNumber: FrameVersionNumber.firstDefault,
    );
  }

  /// Creates a protocol ID with user-specified values.
  Uint32FrameProtocolID createCustomProtocolID({
    required FrameProtocolType protocolType,
    required FrameCompressionType compressionType,
    required FrameEncodingType encodingType,
    required FrameVersionNumber versionNumber,
  }) {
    return Uint32FrameProtocolID.fromValues(
      frameCompressionType: compressionType,
      frameEncodingType: encodingType,
      frameProtocolType: protocolType,
      frameVersionNumber: versionNumber,
    );
  }
}
