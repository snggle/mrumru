import 'package:example/cubit/duplex_tab_cubit/duplex_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class DuplexTabCubit extends Cubit<DuplexTabState> {
  final FrameSettingsModel _frameSettingsModel = FrameSettingsModel.withDefaults();
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController sendingTextController = TextEditingController();

  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();

  DuplexController? _duplexController;

  DuplexTabCubit() : super(const DuplexTabState(processingBool: false));

  Future<void> send() async {
    emit(const DuplexTabState(processingBool: true));
    _initDuplexController();
    await _duplexController!.send(sendingTextController.text);
  }

  Future<void> receive() async {
    emit(const DuplexTabState(processingBool: true));
    _initDuplexController();
    await _duplexController!.receive();
  }

  void stopProcess() {
    _duplexController?.kill();
    emit(const DuplexTabState(processingBool: false));
  }

  void _initDuplexController() {
    messageTextController.clear();
    _duplexController = DuplexController(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: _frameSettingsModel,
      duplexControllerNotifier: DuplexControllerNotifier(
        onEmitMessage: (String message) {
          messageTextController.text += 'Emitted $message\n';
        },
        onMessageReceived: (String message) {
          messageTextController.text += 'Received $message\n';
        },
      ),
    );
  }
}
