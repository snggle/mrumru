import 'package:example/cubit/duplex_tab_cubit/a_duplex_tab_state.dart';
import 'package:example/cubit/duplex_tab_cubit/states/duplex_tab_emission_state.dart';
import 'package:example/cubit/duplex_tab_cubit/states/duplex_tab_empty_state.dart';
import 'package:example/cubit/duplex_tab_cubit/states/duplex_tab_recording_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class DuplexTabCubit extends Cubit<ADuplexTabState> {
  final FrameSettingsModel frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController sendingTextController = TextEditingController();

  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();

  DuplexController? duplexController;

  DuplexTabCubit() : super(DuplexTabEmptyState());

  Future<void> send() async {
    duplexController = DuplexController(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
      duplexControllerNotifier: DuplexControllerNotifier(
        onEmitMessage: (String message) {
          messageTextController.text += 'Emitted $message\n';
        },
        onMessageReceived: (String message) {
          if (message != '') {
            messageTextController.text += 'Received $message\n';
            emit(DuplexTabRecordingState());
          }
        },
      ),
    );
    emit(DuplexTabEmissionState());
    await duplexController?.send(sendingTextController.text);
  }

  Future<void> receive() async {
    duplexController = DuplexController(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: frameSettingsModel,
      duplexControllerNotifier: DuplexControllerNotifier(
        onEmitMessage: (String message) {
          messageTextController.text += 'Emitted $message\n';
          emit(DuplexTabEmissionState());
        },
        onMessageReceived: (String message) {
          if (message != '') {
            messageTextController.text += 'Received $message\n';
            emit(DuplexTabRecordingState());
          }
        },
      ),
    );
    emit(DuplexTabRecordingState());
    await duplexController?.receive();
  }

  void stopProcess() {
    duplexController?.kill();
    emit(DuplexTabEmptyState());
  }
}
