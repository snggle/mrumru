library mrumru;

/// A library for transmitting data using sound waves.

/// Generates audio samples from text messages.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioGenerator].
///   AudioGenerator audioGenerator = AudioGenerator(
///     audioSink: AudioSink(),
///     audioSettingsModel: AudioSettingsModel(),
///     audioGeneratorNotifier: AudioGeneratorNotifier(),
///   );
///
///   // Generates audio samples from the provided [textMessage] and adds them to the given [AudioSink]
///   audioGenerator.generate(textMessage);
///   ```
export 'package:mrumru/src/audio/generator/audio_generator.dart';
export 'package:mrumru/src/audio/generator/audio_generator_notifier.dart';

/// Sinks provides more organized way of providing or saving samples. It can be used to pass audio samples as multiple data types, such as streams, files, etc
///
/// Usage:
///   ```
///   // Audio multi sink used to pass audio samples to multiple sinks.
///   AudioMultiSink audioMultiSink = AudioMultiSink(<IAudioSink>[audioFileSink, audioStreamSink]);
///
///   // Audio file sink used to save audio samples to a file.
///   AudioFileSink audioFileSink = AudioFileSink(file);
///
///   // Audio stream sink used to pass audio samples to a stream.
///   AudioStreamSink audioStreamSink = AudioStreamSink();
///
///  ```
export 'package:mrumru/src/audio/generator/sink/audio_file_sink.dart';
export 'package:mrumru/src/audio/generator/sink/audio_multi_sink.dart';
export 'package:mrumru/src/audio/generator/sink/audio_stream_sink.dart';
export 'package:mrumru/src/audio/generator/sink/i_audio_sink.dart';

/// Records audio samples from the microphone.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioRecorderController].
///   AudioRecorderController audioRecorderController = AudioRecorderController(
///     audioSettingsModel: AudioSettingsModel(),
///     onRecordingCompleted: () {},
///     onFrameReceived: (FrameModel frameModel) {},
///   );
///
///   // Starts recording audio samples.
///   audioRecorderController.startRecording();
///
///   // Stops recording audio samples.
///   audioRecorderController.stopRecording();
///  ```
export 'package:mrumru/src/audio/recorder/audio_recorder_controller.dart';
export 'package:mrumru/src/shared/dtos/a_base_frame.dart';

/// A class representing a data frame in the protocol.
///
/// Usage:
///   ```
///   // Creates an instance of [DataFrame].
///   DataFrame dataFrame = DataFrame(
///     frameIndex: Uint16.fromInt(0),
///     frameLength: Uint16.fromInt(data.length),
///     data: UintDynamic(data, data.length * BinaryUtils.bitsInByte),
///     frameChecksum: Uint16.fromInt(0),
///   );
///   ```
export 'package:mrumru/src/shared/dtos/data_frame.dart';

/// A class that represents a protocol identifier for a frame.
///
/// Usage:
///   ```dart
///   FrameProtocolID protocolID = FrameProtocolID(
///     compressionMethod: Uint8.fromInt(CompressionMethod.noCompression.value),
///     encodingMethod: Uint8.fromInt(EncodingMethod.defaultMethod.value),
///     protocolType: Uint8.fromInt(ProtocolType.rawDataTransfer.value),
///     versionNumber: Uint8.fromInt(VersionNumber.firstDefault.value),
///   );
///   ```
///
/// OR
///
/// Usage:
///   ```dart
///   FrameProtocolID protocolID = FrameProtocolID.fromValues(
///     compressionMethod: CompressionMethod.noCompression,
///     encodingMethod: EncodingMethod.defaultMethod,
///     protocolType: ProtocolType.rawDataTransfer,
///     versionNumber: VersionNumber.firstDefault,
///   );
///   ```
export 'package:mrumru/src/shared/dtos/frame_protocol_id.dart';

/// A class that represents a metadata frame.
///
/// Usage:
///   ```
///   MetadataFrame metadataFrame = MetadataFrame(
///     frameIndex: Uint16.fromInt(0),
///     frameLength: Uint16.fromInt(128),
///     framesCount: Uint16.fromInt(20),
///     frameProtocolID: FrameProtocolID.fromValues(...),
///     sessionId: Uint32.fromList([1, 2, 3, 4]),
///     compositeChecksum: Uint32.fromList([5, 6, 7, 8]),
///     data: UintDynamic(data, data.length * BinaryUtils.bitsInByte),
///     frameChecksum: Uint16.fromInt(0),
///   );
///
/// OR
///
/// Usage:
///   ```dart
///   MetadataFrame metadataFrame = MetadataFrame.fromValues(
///     frameIndex: 0,
///     frameProtocolID: FrameProtocolID.fromValues(...),
///     sessionId: Uint8List.fromList([1, 2, 3, 4]),
///     data: Uint8List.fromList([1, 2, 3]),
///     dataFrames: [...],
///   );
///   ```
export 'package:mrumru/src/shared/dtos/metadata_frame.dart';

/// Adds audio settings that can be modified to customize the audio structure.
///
/// Usage:
///  ```
///   // Creates an instance of [AudioSettingsModel].
///   AudioSettingsModel audioSettingsModel = AudioSettingsModel(
///     sampleRate: 44100,
///     channels: 1,
///     baseFrequency: 1000,
///     bitDepth: 16,
///     bitsPerFrequency: 4,
///     chunksCount: 4,
///   );
///
///
///   // Creates an instance of [AudioSettingsModel] with default values.
///   AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
///
///   // Modifies the values of [AudioSettingsModel] for example [sampleRate].
///   audioSettingsModel = audioSettingsModel.copyWith(sampleRate: 48000);
///
///   // Get [maxFrequency] value from [AudioSettingsModel] calculated from the provided values.
///   int maxFrequency = audioSettingsModel.maxFrequency;
///
///   // Get [possibleFrequencies] from [AudioSettingsModel] calculated from the provided values.
///   List<int> possibleFrequencies = audioSettingsModel.possibleFrequencies;
///
///   ```
export 'package:mrumru/src/shared/models/audio_settings_model.dart';

/// A class representing a collection of frames.
///
/// Usage:
///   ```dart
///   // Creating an instance of [FrameCollectionModel].
///   FrameCollectionModel frameCollection = FrameCollectionModel([
///     metadataFrame,
///     dataFrame1,
///     dataFrame2,
///   ]);
///
///
///   // Accessing merged binary frames from the collection.
///   String mergedFrames = frameCollection.mergedBinaryFrames;
///
///   // Accessing merged data bytes from the collection.
///   Uint8List mergedData = frameCollection.mergedDataBytes;
///   ```
export 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';
