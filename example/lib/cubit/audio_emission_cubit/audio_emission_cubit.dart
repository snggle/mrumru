import 'package:audioplayers/audioplayers.dart';
import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_empty_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_listening_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class AudioEmissionCubit extends Cubit<AAudioEmissionState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioRecorder audioRecorder = AudioRecorder();
  final TextEditingController messageTextController = TextEditingController();

  late final AudioSettingsModel audioSettingsModel;

  AudioEmissionCubit() : super(AudioEmissionEmptyState()) {
    audioSettingsModel = AudioSettingsModel.withDefaults();
  }

  void playSound() {
    AudioGenerator audioGenerator = AudioGenerator(audioSettingsModel: audioSettingsModel);
    List<int> audioBytes = audioGenerator.generateAudioBytes(messageTextController.text);
    Source source = BytesSource(Uint8List.fromList(audioBytes));
    audioPlayer.play(source);
  }

  void stopSound() {
    audioPlayer.stop();
  }

  void startRecording() {
    try {
      emit(AudioEmissionListeningState());
      audioRecorder.startRecording(audioSettingsModel);
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }

  Future<void> stopRecording() async {
    try {
      AudioDecoder audioDecoder = AudioDecoder(audioSettingsModel: audioSettingsModel);
      Uint8List recordedBytes = await audioRecorder.stopRecording();
      String receivedText = await audioDecoder.decodeRecordedAudio(recordedBytes);
      emit(AudioEmissionResultState(decodedMessage: receivedText));
    } catch (e) {
      AppLogger().log(message: 'Cannot stop recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }
}
