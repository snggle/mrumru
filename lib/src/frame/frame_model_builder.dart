import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_processor.dart';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/models/frame/data_frame.dart';
import 'package:mrumru/src/shared/models/frame/metadata_frame.dart';

class FrameModelBuilder {
  final FrameProcessor frameProcessor;
  final FrameSettingsModel frameSettingsModel;

  FrameModelBuilder({
    required this.frameProcessor,
    required this.frameSettingsModel,
  });

  FrameCollectionModel buildFramesList(String rawDataString) {
    final List<ABaseFrame> framesList = <ABaseFrame>[];
    final List<Uint8List> frameChecksumsList = <Uint8List>[];
    final int maxDataSizeInt = frameSettingsModel.dataBitsLengthInt ~/ 8;

    final List<String> dataChunksList = _splitDataIntoChunksList(rawDataString, maxDataSizeInt);
    final int framesCountInt = dataChunksList.length;

    const String sessionIdString = ''; // dodać secure random

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
        frameChecksumsList.add(Uint8List.fromList(metadataFrame.frameChecksumString.codeUnits));
      } else {
        final DataFrame dataFrame = _buildDataFrame(
          dataString: dataChunksList[i],
          frameIndexInt: i,
        );
        framesList.add(dataFrame);
        frameChecksumsList.add(Uint8List.fromList(dataFrame.frameChecksumString.codeUnits));
      }
    }

    final Uint8List compositeChecksumUint8List = frameProcessor.computeCompositeChecksumUint8List(frameChecksumsList);

    final MetadataFrame firstMetadataFrame = framesList[0] as MetadataFrame;
    final MetadataFrame updatedFirstMetadataFrame = MetadataFrame(
      frameIndexInt: firstMetadataFrame.frameIndexInt,
      frameLengthInt: firstMetadataFrame.frameLengthInt,
      framesCountInt: firstMetadataFrame.framesCountInt,
      protocolIdInt: firstMetadataFrame.protocolIdInt,
      sessionIdString: firstMetadataFrame.sessionIdString,
      compositeChecksumString: String.fromCharCodes(compositeChecksumUint8List),
      dataString: firstMetadataFrame.dataString,
      frameChecksumString: firstMetadataFrame.frameChecksumString,
    );

    framesList[0] = updatedFirstMetadataFrame;

    return FrameCollectionModel(framesList);
  }

  MetadataFrame _buildMetadataFrame({
    required String dataString,
    required int frameIndexInt,
    required int framesCountInt,
    required int protocolIdInt,
    required String sessionIdString,
  }) {
    final int frameLengthInt = (frameSettingsModel.frameIndexBitsLengthInt +
            frameSettingsModel.frameLengthBitsLengthInt +
            frameSettingsModel.framesCountBitsLengthInt +
            frameSettingsModel.protocolIdBitsLengthInt +
            frameSettingsModel.sessionIdBitsLengthInt +
            frameSettingsModel.compositeChecksumBitsLengthInt +
            dataString.length * 8 +
            frameSettingsModel.checksumBitsLengthInt) ~/
        8;

    const String compositeChecksumString = '';

    final MetadataFrame metadataFrame = MetadataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      framesCountInt: framesCountInt,
      protocolIdInt: protocolIdInt,
      sessionIdString: sessionIdString,
      compositeChecksumString: compositeChecksumString,
      dataString: dataString,
      frameChecksumString: '',
    );

    final Uint8List frameBytesWithoutChecksumUint8List = metadataFrame
        .toBytes(frameSettingsModel)
        .sublist(0, metadataFrame.toBytes(frameSettingsModel).length - (frameSettingsModel.checksumBitsLengthInt ~/ 8));

    final String frameChecksumString = frameProcessor.computeFrameChecksumString(frameBytesWithoutChecksumUint8List);

    return MetadataFrame(
      frameIndexInt: metadataFrame.frameIndexInt,
      frameLengthInt: metadataFrame.frameLengthInt,
      framesCountInt: metadataFrame.framesCountInt,
      protocolIdInt: metadataFrame.protocolIdInt,
      sessionIdString: metadataFrame.sessionIdString,
      compositeChecksumString: metadataFrame.compositeChecksumString,
      dataString: metadataFrame.dataString,
      frameChecksumString: frameChecksumString,
    );
  }

  DataFrame _buildDataFrame({
    required String dataString,
    required int frameIndexInt,
  }) {
    final int frameLengthInt = (frameSettingsModel.frameIndexBitsLengthInt +
            frameSettingsModel.frameLengthBitsLengthInt +
            dataString.length * 8 +
            frameSettingsModel.checksumBitsLengthInt) ~/
        8;

    final DataFrame dataFrame = DataFrame(
      frameIndexInt: frameIndexInt,
      frameLengthInt: frameLengthInt,
      dataString: dataString,
      frameChecksumString: '',
    );

    final Uint8List frameBytesWithoutChecksumUint8List =
        dataFrame.toBytes(frameSettingsModel).sublist(0, dataFrame.toBytes(frameSettingsModel).length - (frameSettingsModel.checksumBitsLengthInt ~/ 8));

    final String frameChecksumString = frameProcessor.computeFrameChecksumString(frameBytesWithoutChecksumUint8List);

    return DataFrame(
      frameIndexInt: dataFrame.frameIndexInt,
      frameLengthInt: dataFrame.frameLengthInt,
      dataString: dataFrame.dataString,
      frameChecksumString: frameChecksumString,
    );
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
