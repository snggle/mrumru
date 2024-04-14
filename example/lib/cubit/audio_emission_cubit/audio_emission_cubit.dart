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
  final FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();

  late AudioRecorder audioRecorderController;
  late AudioSettingsModel audioSettingsModel;

  AudioEmitter? audioEmitter;

  AudioEmissionCubit() : super(AudioEmissionEmptyState()) {
    audioSettingsModel = AudioSettingsModel.withDefaults();
  }

  void playSound(String text) {
    audioEmitter = AudioEmitter(
      audioSink: StreamAudioSink(),
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
    )..play(text);
  }

  void stopSound() {
    audioEmitter?.stop();
  }

  void startRecording() {
    try {
      audioRecorderController = AudioRecorder(
        audioSettingsModel: audioSettingsModel,
        frameSettingsModel: frameSettingsModel,
        audioSource: StreamAudioSource(audioSettingsModel: audioSettingsModel),
      );
      emit(AudioEmissionListeningState(decodedMessage: ''));
      audioRecorderController.startRecording();
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }

  void stopRecording() {
    audioRecorderController.stopRecording();
  }

  void _handleRecordingCompleted() {
    emit(AudioEmissionResultState(decodedMessage: (state as AudioEmissionListeningState).decodedMessage));
  }

  void _handleFrameReceived(FrameModel frameModel) {
    String decodedMessage = frameModel.rawData;
    if (state is AudioEmissionResultState) {
      decodedMessage = '${(state as AudioEmissionResultState).decodedMessage}$decodedMessage';
    }
    emit(AudioEmissionListeningState(decodedMessage: decodedMessage));
  }
}
