import 'dart:async';
import 'dart:io';
import 'package:example/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:example/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:example/cubit/send_tab_cubit/states/send_tab_empty_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:path_provider/path_provider.dart';

class SendTabCubit extends Cubit<ASendTabState> {
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
  AudioGenerator? _audioGenerator;

  SendTabCubit() : super(SendTabEmptyState());

  Future<void> playSound(String text) async {
    AudioStreamSink audioStreamSink = AudioStreamSink();
    emit(SendTabEmittingState());
    _audioGenerator = AudioGenerator(
      audioSink: audioStreamSink,
      audioSettingsModel: audioSettingsModel,
    );
    await _audioGenerator!.generate(text);

    await audioStreamSink.future;

    emit(SendTabEmptyState());
  }

  Future<void> playSoundAndSave(String text) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File wavFile = File('${appDirectory.path}/generated_wav.wav');
    AudioMultiSink audioMultiSink = AudioMultiSink(<IAudioSink>[
      AudioStreamSink(),
      AudioFileSink(wavFile),
    ]);
    emit(SendTabEmittingState());
    _audioGenerator = AudioGenerator(
      audioSink: audioMultiSink,
      audioSettingsModel: audioSettingsModel,
    );
    unawaited(_audioGenerator?.generate(text));

    await audioMultiSink.future;

    emit(SendTabEmptyState());
  }

  void stopSound() {
    _audioGenerator?.stop();
    emit(SendTabEmptyState());
  }
}
