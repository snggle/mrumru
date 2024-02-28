// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mrumru/mrumru.dart';
// import 'package:wav/wav_file.dart';
//
// void main() async {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   // Arrange
//   AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 8);
//   FrameSettingsModel actualFrameSettingsModel = FrameSettingsModel.withDefaults();
//
//   File actualGeneratedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFF/generated.wav');
//   File actualTrimmedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFF/trim.wav');
//   File actualTrimmedManualFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFF/trim_manual.wav');
//   File actualTrimmedManualCompleteFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFF/trim_manual_complete.wav');
//
//   // File actualGeneratedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGG/generated.wav');
//   // File actualTrimmedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGG/trim.wav');
//   // File actualTrimmedManualFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGG/trim_manual.wav');
//   // File actualTrimmedManualCompleteFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGG/trim_manual_complete.wav');
//
//   // File actualGeneratedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGGHHH/generated.wav');
//   // File actualTrimmedFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGGHHH/trim.wav');
//   // File actualTrimmedManualFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGGHHH/trim_manual.wav');
//   // File actualTrimmedManualCompleteFile = File('/home/dpajak99/Storage/GitHub/fdm/input/FDM8/AAABBBCCCDDDEEEFFFGGGHHH/trim_manual_complete.wav');
//
//   // try {
//   //   Uint8List generatedFileBytes = await actualGeneratedFile.readAsBytes();
//   //   Wav wav = Wav.read(Uint8List.fromList(generatedFileBytes));
//   //   String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//   //
//   //   print('Expected: $result');
//   // } catch (_) {
//   //   print('Failed to read generated file');
//   // }
//   //
//   // try {
//   //   Uint8List trimmedFileBytes = await actualTrimmedFile.readAsBytes();
//   //   Wav wav = Wav.read(Uint8List.fromList(trimmedFileBytes));
//   //   String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//   //
//   //   print('Trimmed (Python): $result');
//   // } catch (_) {
//   //   print('Failed to read trimmed file (Python)');
//   // }
//   //
//   // try {
//   //   Uint8List trimmedFileBytes = await actualTrimmedManualFile.readAsBytes();
//   //   Wav wav = Wav.read(Uint8List.fromList(trimmedFileBytes));
//   //   String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//   //
//   //   print('Manual (start only): $result');
//   // } catch (_) {
//   //   print('Failed to read manually trimmed file (start only)');
//   // }
//   //
//   //
//   // try {
//   //   Uint8List trimmedFileBytes = await actualTrimmedManualCompleteFile.readAsBytes();
//   //   Wav wav = Wav.read(Uint8List.fromList(trimmedFileBytes));
//   //   String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//   //
//   //   print('Manual (full): $result');
//   // } catch (_) {
//   //   print('Failed to read manually trimmed file (full trimming)');
//   // }
//
//   try {
//     File actualTrimmedManualCompleteFile = File('/home/dpajak99/Storage/GitHub/KIRA/mrumru/test/integration/assets/mocked_wave_file.wav');
//
//     Uint8List trimmedFileBytes = await actualTrimmedManualCompleteFile.readAsBytes();
//     Wav wav = Wav.read(Uint8List.fromList(trimmedFileBytes));
//     // String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//     //
//     // print('Expected: $result');
//   } catch (_) {
//     print('Failed to read file');
//   }
//
//   print('******************************************************');
//
//   try {
//     File actualTrimmedManualCompleteFile = File('/home/dpajak99/Storage/GitHub/KIRA/mrumru/test/integration/assets/1708676097139full.wav');
//
//     Uint8List trimmedFileBytes = await actualTrimmedManualCompleteFile.readAsBytes();
//     Wav wav = Wav.read(Uint8List.fromList(trimmedFileBytes));
//     // String result = actualAudioDecoder.decodeRecordedAudio(wav.channels.first);
//     //
//     // print('Decoded: $result');
//   } catch (_) {
//     print('Failed to read file');
//   }
// }
