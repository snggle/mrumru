library mrumru;

/// A library for transmitting data using sound waves.
/// Provides a duplex controller that can be used to send and receive messages.
///
/// Usage:
///   ```
///   // Creates an instance of [DuplexController].
///   DuplexController duplexController = DuplexController(
///     audioSettingsModel: AudioSettingsModel(),
///     frameSettingsModel: FrameSettingsModel(),
///     duplexControllerNotifier: DuplexControllerNotifier(
///     onEmitMessage: (String message) {},
///     onMessageReceived: (String message) {},
///    ),
///    );
///
///   // Sends a message using the [DuplexController].
///   duplexController.send('Hello World!');
///
///   // Receives a message using the [DuplexController].
///   duplexController.receive();
///   ```
export 'package:mrumru/src/audio/duplex/duplex_controller.dart';
export 'package:mrumru/src/audio/duplex/duplex_controller_notifier.dart';
/// A library for transmitting data using sound waves.

/// Generates audio samples from text messages.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioGenerator].
///   AudioGenerator audioGenerator = AudioGenerator(
///     audioSink: AudioSink(),
///     audioSettingsModel: AudioSettingsModel(),
///     frameSettingsModel: FrameSettingsModel(),
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
///     frameSettingsModel: FrameSettingsModel(),
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
export 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

/// Provides model of frame used to encode and decode data.
///
/// Usage:
///  ```
///   // Creates an instance of [FrameModel].
///   FrameModel frameModel = FrameModel(
///     frameIndex: 0,
///     framesCount: 20,
///     rawData: '1234',
///     frameSettings: FrameSettingsModel(),
///   );
///
///   // Get [mergedBinaryFrames] from [FrameModel] created from decoded content of the frame.
///   String mergedBinaryFrames = frameModel.mergedBinaryFrames;
///
///   // Create from binary string frame for decoding.
///   FrameModel frameModel = FrameModel.fromBinaryString('101010101010101010101010');
///
///   // Get [binaryString] from [FrameModel] created from decoded content of the frame.
///   String binaryString = frameModel.binaryString;
///
///   // Get [transferWavLength] from [FrameModel] calculated from the provided values.
///   int transferWavLength = frameModel.getTransferWavLength(audioSettingsModel);
///  ```
export 'package:mrumru/src/shared/models/frame/frame_model.dart';

/// Adds frame settings that are can be modified to customize the frame structure.
///
/// Usage:
///  ```
///   // Creates an instance of [FrameSettingsModel].
///   FrameSettingsModel frameSettingsModel = FrameSettingsModel(
///     frameIndexBitsLength: 4,
///     framesCountBitsLength: 4,
///     dataBitsLength: 8,
///     checksumBitsLength: 4,
///   );
///
///   // Creates an instance of [FrameSettingsModel] with default values.
///   FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
///  ```
export 'package:mrumru/src/shared/models/frame/frame_settings_model.dart';
export 'package:mrumru/src/shared/utils/duplex_utils.dart';
