import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_empty_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_generating_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_listening_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_result_state.dart';
import 'package:example/shared/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:path_provider/path_provider.dart';

class AudioEmissionCubit extends Cubit<AAudioEmissionState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();

  AudioGenerator? audioGenerator;

  late AudioRecorderController audioRecorderController;
  late AudioSettingsModel audioSettingsModel;

  AudioEmissionCubit() : super(AudioEmissionEmptyState()) {
    audioSettingsModel = AudioSettingsModel.withDefaults();
  }

  Future<void> playSound(String text) async {
    AudioStreamSink audioStreamSink = AudioStreamSink();
    emit(AudioEmissionGeneratingState());
    audioGenerator = AudioGenerator(
      audioSink: audioStreamSink,
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
    );
    await audioGenerator!.generate(text);

    await audioStreamSink.future;

    emit(AudioEmissionEmptyState());
  }

  Future<void> playSoundAndSave(String text) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File wavFile = File('${appDirectory.path}/generated_wav.wav');
    AudioMultiSink audioMultiSink = AudioMultiSink(<IAudioSink>[
      AudioStreamSink(),
      AudioFileSink(wavFile),
    ]);
    emit(AudioEmissionGeneratingState());
    audioGenerator = AudioGenerator(
      audioSink: audioMultiSink,
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
    );
    unawaited(audioGenerator?.generate(text));

    await audioMultiSink.future;

    emit(AudioEmissionEmptyState());
  }

  void stopSound() {
    audioGenerator?.stop();
    emit(AudioEmissionEmptyState());
  }

  void startRecording() {
    try {
      audioRecorderController = AudioRecorderController(
        audioSettingsModel: audioSettingsModel,
        frameSettingsModel: frameSettingsModel,
        onRecordingCompleted: _handleRecordingCompleted,
        onFrameReceived: _handleFrameReceived,
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
