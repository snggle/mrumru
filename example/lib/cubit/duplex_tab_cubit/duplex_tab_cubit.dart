import 'package:example/cubit/duplex_tab_cubit/duplex_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class DuplexTabCubit extends Cubit<DuplexTabState> {
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController sendingTextController = TextEditingController();

  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();

  final FrameSettingsModel _frameSettingsModel = FrameSettingsModel.withDefaults();
  DuplexController? _duplexController;

  DuplexTabCubit() : super(DuplexTabState(processingBool: false));

  Future<void> send() async {
    emit(DuplexTabState(processingBool: true));
    initDuplexController();
    await _duplexController!.send(sendingTextController.text, DuplexFlag.single);
  }

  Future<void> receive() async {
    emit(DuplexTabState(processingBool: true));
    initDuplexController();
    await _duplexController!.receive();
  }

  void stopProcess() {
    _duplexController?.kill();
    emit(DuplexTabState(processingBool: false));
  }

  void initDuplexController() {
    _duplexController = DuplexController(
      audioSettingsModel: audioSettingsModel,
      frameSettingsModel: _frameSettingsModel,
      duplexControllerNotifier: DuplexControllerNotifier(
        onEmitMessage: (String message) {
          messageTextController.text += 'Emitted $message\n';
        },
        onMessageReceived: (String message) {
          if (message != '') {
            messageTextController.text += 'Received $message\n';
          }
        },
      ),
    );
  }
}
