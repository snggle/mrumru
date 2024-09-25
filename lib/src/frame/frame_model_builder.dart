import 'dart:convert';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
class FrameModelBuilder {
  final FrameProcessor frameProcessor;
  final FrameSettingsModel frameSettingsModel;

  FrameModelBuilder({
    required this.frameSettingsModel,
  }) : frameProcessor = FrameProcessor();

  FrameCollectionModel buildFrameCollection(String rawDataString) {
    final List<ABaseFrame> framesList = <ABaseFrame>[];
    final List<Uint8List> frameChecksumsList = <Uint8List>[];
    final int maxDataSizeInt = frameSettingsModel.dataBitsLengthInt ~/ 8;

    final List<String> dataChunksList = _splitDataIntoChunksList(rawDataString, maxDataSizeInt);
    final int framesCountInt = dataChunksList.length;

    final String sessionIdString = _generateSessionId();

    for (int i = 0; i < framesCountInt; i++) {
      if (i == 0) {
        final MetadataFrame metadataFrame = _buildMetadataFrame(
          dataString: dataChunksList[i],
          frameIndexInt: i,
          framesCountInt: framesCountInt,
          protocolIdInt: _getProtocolIdInt(),
          sessionIdString: sessionIdString,
        );
        framesList.add(metadataFrame);
        frameChecksumsList.add(metadataFrame.frameChecksumUint8List);
      } else {
        final DataFrame dataFrame = _buildDataFrame(
          dataString: dataChunksList[i],
          frameIndexInt: i,
        );
        framesList.add(dataFrame);
        frameChecksumsList.add(dataFrame.frameChecksumUint8List);
      }
    }

    final Uint8List compositeChecksumUint8List = frameProcessor.computeCompositeChecksum(frameChecksumsList);

    final MetadataFrame firstMetadataFrame = framesList[0] as MetadataFrame;
    final MetadataFrame updatedFirstMetadataFrame = MetadataFrame(
      frameIndexInt: firstMetadataFrame.frameIndexInt,
      frameLengthInt: firstMetadataFrame.frameLengthInt,
      framesCountInt: firstMetadataFrame.framesCountInt,
      protocolIdInt: firstMetadataFrame.protocolIdInt,
      sessionIdString: firstMetadataFrame.sessionIdString,
      compositeChecksumUint8List: compositeChecksumUint8List,
      dataString: firstMetadataFrame.dataString,
      frameChecksumUint8List: firstMetadataFrame.frameChecksumUint8List,
    );

    final Uint8List firstFrameBytesWithoutChecksum = updatedFirstMetadataFrame.toBytes(frameSettingsModel).sublist(
        0,
        updatedFirstMetadataFrame.toBytes(frameSettingsModel).length - (frameSettingsModel.checksumBitsLengthInt ~/ 8));

    final Uint8List firstFrameChecksum = frameProcessor.computeFrameChecksum(firstFrameBytesWithoutChecksum.toString());

    final MetadataFrame finalFirstFrame = MetadataFrame(
      frameIndexInt: updatedFirstMetadataFrame.frameIndexInt,
      frameLengthInt: updatedFirstMetadataFrame.frameLengthInt,
      framesCountInt: updatedFirstMetadataFrame.framesCountInt,
      protocolIdInt: updatedFirstMetadataFrame.protocolIdInt,
      sessionIdString: updatedFirstMetadataFrame.sessionIdString,
      compositeChecksumUint8List: updatedFirstMetadataFrame.compositeChecksumUint8List,
      dataString: updatedFirstMetadataFrame.dataString,
      frameChecksumUint8List: firstFrameChecksum,
    );

    framesList[0] = finalFirstFrame;

    return FrameCollectionModel(framesList);
  }

  String _generateSessionId() {
    Uint8List randomBytes = CryptoUtils.getBytes(length: frameSettingsModel.sessionIdBitsLengthInt ~/ 8, max: frameSettingsModel.sessionIdBitsLengthInt ~/ 8);
    return base64Url.encode(randomBytes);
  }

  MetadataFrame _buildMetadataFrame({
    required String dataString,
    required int frameIndexInt,
    required int framesCountInt,
    required int protocolIdInt,
    required String sessionIdString,
  }) {
    final int frameLengthInt = _calculateFrameLength(dataString, isMetadataFrame: true);

    final MetadataFrame metadataFrame = MetadataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      framesCountInt: framesCountInt,
      protocolIdInt: protocolIdInt,
      sessionIdString: sessionIdString,
      compositeChecksumUint8List: Uint8List(frameSettingsModel.compositeChecksumBitsLengthInt ~/ 8),
      dataString: dataString,
      frameChecksumUint8List: Uint8List(frameSettingsModel.checksumBitsLengthInt ~/ 8),
    );

    final Uint8List frameBytesWithoutChecksum = metadataFrame.toBytes(frameSettingsModel).sublist(
        0, metadataFrame.toBytes(frameSettingsModel).length - (frameSettingsModel.checksumBitsLengthInt ~/ 8));

    final Uint8List frameChecksumUint8List = frameProcessor.computeFrameChecksum(frameBytesWithoutChecksum.toString());

    return MetadataFrame(
      frameIndexInt: metadataFrame.frameIndexInt,
      frameLengthInt: metadataFrame.frameLengthInt,
      framesCountInt: metadataFrame.framesCountInt,
      protocolIdInt: metadataFrame.protocolIdInt,
      sessionIdString: metadataFrame.sessionIdString,
      compositeChecksumUint8List: metadataFrame.compositeChecksumUint8List,
      dataString: metadataFrame.dataString,
      frameChecksumUint8List: frameChecksumUint8List,
    );
  }

  DataFrame _buildDataFrame({
    required String dataString,
    required int frameIndexInt,
  }) {
    final int frameLengthInt = _calculateFrameLength(dataString, isMetadataFrame: false);

    final DataFrame dataFrame = DataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      dataString: dataString,
      frameChecksumUint8List: Uint8List(frameSettingsModel.checksumBitsLengthInt ~/ 8),
    );

    final Uint8List frameBytesWithoutChecksum = dataFrame.toBytes(frameSettingsModel).sublist(
        0, dataFrame.toBytes(frameSettingsModel).length - (frameSettingsModel.checksumBitsLengthInt ~/ 8));

    final Uint8List frameChecksumUint8List = frameProcessor.computeFrameChecksum(frameBytesWithoutChecksum.toString());

    return DataFrame(
      frameIndexInt: dataFrame.frameIndexInt,
      frameLengthInt: dataFrame.frameLengthInt,
      dataString: dataFrame.dataString,
      frameChecksumUint8List: frameChecksumUint8List,
    );
  }

  int _calculateFrameLength(String dataString, {required bool isMetadataFrame}) {
    int lengthInBits = 0;
    lengthInBits += frameSettingsModel.frameIndexBitsLengthInt;
    lengthInBits += frameSettingsModel.frameLengthBitsLengthInt;

    if (isMetadataFrame) {
      lengthInBits += frameSettingsModel.framesCountBitsLengthInt;
      lengthInBits += frameSettingsModel.protocolIdBitsLengthInt;
      lengthInBits += frameSettingsModel.sessionIdBitsLengthInt;
      lengthInBits += frameSettingsModel.compositeChecksumBitsLengthInt;
    }

    lengthInBits += dataString.length * 8;
    lengthInBits += frameSettingsModel.checksumBitsLengthInt;

    return lengthInBits ~/ 8;
  }

  List<String> _splitDataIntoChunksList(String dataString, int maxChunkSizeInt) {
    final List<String> chunksList = <String>[];
    for (int i = 0; i < dataString.length; i += maxChunkSizeInt) {
      final int endInt = (i + maxChunkSizeInt < dataString.length) ? i + maxChunkSizeInt : dataString.length;
      chunksList.add(dataString.substring(i, endInt));
    }
    return chunksList;
  }

  int _getProtocolIdInt() {
    return 1;
  }
}
