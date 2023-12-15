import 'package:audioplayers/audioplayers.dart';
import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_empty_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_listening_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_result_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class AudioEmissionCubit extends Cubit<AAudioEmissionState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();

  late AudioRecorderController audioRecorderController;
  late AudioSettingsModel audioSettingsModel;

  AudioEmissionCubit() : super(AudioEmissionEmptyState()) {
    audioSettingsModel = AudioSettingsModel.withDefaults();
  }

  void playSound() {
    AudioGenerator audioGenerator = AudioGenerator(audioSettingsModel: audioSettingsModel, frameSettingsModel: frameSettingsModel);
    List<int> audioBytes = audioGenerator.generateAudioBytes(messageTextController.text);
    Source source = BytesSource(Uint8List.fromList(audioBytes));
    audioPlayer.play(source);
  }

  void stopSound() {
    audioPlayer.stop();
  }

  void startRecording() {
    try {
      audioRecorderController = AudioRecorderController(audioSettingsModel: audioSettingsModel);
      emit(AudioEmissionListeningState());
      audioRecorderController.startRecording();
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }

  Future<void> stopRecording() async {
    try {
      AudioDecoder audioDecoder = AudioDecoder(audioSettingsModel: audioSettingsModel, frameSettingsModel: frameSettingsModel);
      List<double> recordedWavBytes = await audioRecorderController.stopRecording();
      String receivedText = await audioDecoder.decodeRecordedAudio(recordedWavBytes);
      emit(AudioEmissionResultState(decodedMessage: receivedText));
    } catch (e) {
      AppLogger().log(message: 'Cannot stop recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }

  set baseFrequency(int baseFrequency) {
    audioSettingsModel = audioSettingsModel.copyWith(baseFrequency: baseFrequency);
  }

  set bitDepth(int bitDepth) {
    audioSettingsModel = audioSettingsModel.copyWith(bitDepth: bitDepth);
  }

  set bitsPerFrequency(int bitsPerFrequency) {
    audioSettingsModel = audioSettingsModel.copyWith(bitsPerFrequency: bitsPerFrequency);
  }

  set channels(int channels) {
    audioSettingsModel = audioSettingsModel.copyWith(channels: channels);
  }

  set chunksCount(int chunksCount) {
    audioSettingsModel = audioSettingsModel.copyWith(chunksCount: chunksCount);
  }

  set frequencyGap(int frequencyGap) {
    audioSettingsModel = audioSettingsModel.copyWith(frequencyGap: frequencyGap);
  }

  set symbolDuration(double symbolDuration) {
    audioSettingsModel = audioSettingsModel.copyWith(symbolDuration: symbolDuration);
  }
}
