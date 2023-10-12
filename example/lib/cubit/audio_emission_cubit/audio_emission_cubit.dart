import 'dart:convert';

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
  final Recorder recorder = Recorder();
  final FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();

  late final AudioSettingsModel audioSettingsModel;

  AudioEmissionCubit() : super(AudioEmissionEmptyState()) {
    audioSettingsModel = AudioSettingsModel.withDefaults();
  }

  void playSound() {
    AudioGenerator audioGenerator = AudioGenerator(audioSettingsModel: audioSettingsModel, frameSettingsModel: frameSettingsModel);
    List<int> audioBytes = audioGenerator.generateAudioBytes(messageTextController.text);
    late Source source;
    if (kIsWeb) {
      source = UrlSource('data:audio/wav;base64,${base64Encode(audioBytes)}');
    } else {
      source = BytesSource(Uint8List.fromList(audioBytes));
    }
    audioPlayer.play(source);
  }

  void stopSound() {
    audioPlayer.stop();
  }

  void startRecording() {
    try {
        emit(AudioEmissionListeningState());
        recorder.startRecording(audioSettingsModel);
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }

  Future<void> stopRecording() async {
    try {
      AudioDecoder audioDecoder = AudioDecoder(audioSettingsModel: audioSettingsModel, frameSettingsModel: frameSettingsModel);
      Uint8List recordedBytes = await recorder.stopRecording();
      String receivedText = await audioDecoder.decodeRecordedAudio(recordedBytes);
      emit(AudioEmissionResultState(decodedMessage: receivedText));
    } catch (e) {
      AppLogger().log(message: 'Cannot stop recording: $e');
      emit(AudioEmissionEmptyState());
    }
  }
}
