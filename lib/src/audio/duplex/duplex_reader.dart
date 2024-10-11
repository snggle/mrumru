import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/protocol/frame_compression_type.dart';
import 'package:mrumru/src/frame/protocol/frame_encoding_type.dart';
import 'package:mrumru/src/frame/protocol/frame_protocol_type.dart';
import 'package:mrumru/src/frame/protocol/frame_version_number.dart';

/// Class to interpret metadata from a frame and determine the type of transmission.
/// This class can also decide whether the transmission requires a response.
class DuplexReader {
  /// The metadata frame that contains information about the transmission.
  final MetadataFrame metadataFrame;

  /// Creates an instance of [DuplexReader].
  DuplexReader({required this.metadataFrame});

  /// Determines the type of transmission based on the protocol type.
  FrameProtocolType get protocolType => FrameProtocolType.fromValue(metadataFrame.frameProtocolID.frameProtocolType.toInt());

  /// Determines whether a response is required based on the protocol type.
  bool get requiresResponse {
    switch (protocolType) {
      case FrameProtocolType.simpleHandshake:
      case FrameProtocolType.endToEndEncryption:
      case FrameProtocolType.dataPartiallyReceived:
      case FrameProtocolType.failedToReceiveData:
        return true;
      case FrameProtocolType.rawDataTransfer:
      case FrameProtocolType.calibrationTest:
      case FrameProtocolType.allDataReceived:
        return false;
      case FrameProtocolType.undefined:
      default:
        return false;
    }
  }

  /// Gets the compression type used in the frame.
  FrameCompressionType get compressionType => FrameCompressionType.fromValue(metadataFrame.compressionTypeValue);

  /// Gets the encoding type used in the frame.
  FrameEncodingType get encodingType => FrameEncodingType.fromValue(metadataFrame.encodingTypeValue);

  /// Gets the version number of the frame protocol.
  FrameVersionNumber get versionNumber => FrameVersionNumber.fromValue(metadataFrame.versionNumberValue);

  /// Provides a summary of the frame's metadata.
  String get frameSummary {
    return 'Protocol Type: $protocolType, Requires Response: $requiresResponse, '
        'Compression Type: $compressionType, Encoding Type: $encodingType, '
        'Version Number: $versionNumber';
  }
}