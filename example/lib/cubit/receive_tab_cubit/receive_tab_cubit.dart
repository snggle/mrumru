import 'dart:convert';
import 'dart:typed_data';

import 'package:example/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:example/shared/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceiveTabCubit extends Cubit<AReceiveTabState> {
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
  late AudioRecorderController _audioRecorderController;

  ReceiveTabCubit() : super(AudioRecordingEmptyState()) {
    _requestMicPermission();
  }

  void startRecording() {
    try {
      _audioRecorderController = AudioRecorderController(
        audioSettingsModel: audioSettingsModel,
        onRecordingCompleted: _handleRecordingCompleted,
        onFrameReceived: _handleFrameReceived,
      );
      emit(ReceiveTabRecordingState(decodedMessage: ''));
      _audioRecorderController.startRecording();
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioRecordingEmptyState());
    }
  }

  void stopRecording() {
    _audioRecorderController.stopRecording();
  }

  Future<void> _requestMicPermission() async {
    Permission micPermission = Permission.microphone;
    if (await micPermission.isGranted == false) {
      PermissionStatus permissionStatus = await micPermission.request();
      assert(permissionStatus.isGranted, 'Permission ${micPermission.toString()} must be granted to use application');
    }
  }

  void _handleRecordingCompleted(FrameCollectionModel frameCollectionModel) {
    Uint8List bytes = frameCollectionModel.mergedRawDataBytes;
    String decodedMessage = utf8.decode(bytes);
    emit(ReceiveTabResultState(decodedMessage: decodedMessage));
  }

  void _handleFrameReceived(DataFrame frameBase) {}
}
