library mrumru;

/// A library for transmitting data using sound waves.

/// Generates audio samples from text messages.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioGenerator] with the provided [audioSettingsModel] and [frameSettingsModel].
///   AudioGenerator audioGenerator = AudioGenerator(audioSettingsModel: audioSettingsModel, frameSettingsModel: frameSettingsModel);
///
///   // Generates audio samples from the provided [textMessage].
///   List<double> waveBytes = audioGenerator.generateSamples(textMessage);
///
///   // Generates a WAV file from the provided [textMessage].
///   Uint8List audioBytes = audioGenerator.generateWavFileBytes(textMessage);
///   ```
export 'package:mrumru/src/audio/generator/audio_generator.dart';
/// Records audio samples from the microphone.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioRecorderController] with the provided [audioSettingsModel], [frameSettingsModel], [onRecordingCompleted] and [onFrameReceived].
///   AudioRecorderController audioRecorderController = AudioRecorderController(
///     audioSettingsModel: audioSettingsModel,
///     frameSettingsModel: frameSettingsModel,
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
///   // Creates an instance of [AudioSettingsModel] with the provided [sampleRate], [channels], [baseFrequency], [bitDepth], [bitsPerFrequency] and [chunksCount].
///   AudioSettingsModel audioSettingsModel = AudioSettingsModel(
///    sampleRate: 44100,
///    channels: 1,
///    baseFrequency: 1000,
///    bitDepth: 16,
///    bitsPerFrequency: 4,
///    chunksCount: 4,
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
export 'package:mrumru/src/shared/models/audio_settings.dart';
/// Provides model of frame used to encode and decode data.
///
/// Usage:
///  ```
///   // Creates an instance of [FrameModel] with the provided [frameIndex], [framesCount], [rawData] and [frameSettings].
///   FrameModel frameModel = FrameModel(
///     frameIndex: 0,
///     framesCount: 20,
///     rawData: '1234',
///     frameSettings: frameSettingsModel,
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
///   // Creates an instance of [FrameSettingsModel] with the provided [frameIndexBitsLength], [framesCountBitsLength], [dataBitsLength] and [checksumBitsLength].
///   FrameSettingsModel frameSettingsModel = FrameSettingsModel(
///    frameIndexBitsLength: 4,
///    framesCountBitsLength: 4,
///    dataBitsLength: 8,
///    checksumBitsLength: 4,
///   );
///
///   // Creates an instance of [FrameSettingsModel] with default values.
///   FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
///  ```
export 'package:mrumru/src/shared/models/frame/frame_settings_model.dart';
