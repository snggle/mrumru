import 'package:example/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:example/shared/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceiveTabCubit extends Cubit<AReceiveTabState> {
  final FrameSettingsModel _frameSettingsModel = FrameSettingsModel.withDefaults();
  final List<Permission> _requiredPermissions = <Permission>[Permission.microphone];

  late AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
  late AudioRecorderController _audioRecorderController;

  ReceiveTabCubit() : super(AudioRecordingEmptyState()) {
    _grantRequiredPermissions();
  }

  void startRecording() {
    try {
      _audioRecorderController = AudioRecorderController(
        audioSettingsModel: audioSettingsModel,
        frameSettingsModel: _frameSettingsModel,
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

  void _handleRecordingCompleted(FrameCollectionModel frameCollectionModel) {
    String decodedMessage = frameCollectionModel.mergedRawData;
    emit(ReceiveTabResultState(decodedMessage: decodedMessage));
  }

  void _handleFrameReceived(FrameModel frameModel) {
    String decodedMessage = frameModel.rawData;
    if (state is ReceiveTabRecordingState) {
      decodedMessage = '${(state as ReceiveTabRecordingState).decodedMessage}$decodedMessage';
    }
    emit(ReceiveTabRecordingState(decodedMessage: decodedMessage));
  }

  Future<void> _grantRequiredPermissions() async {
    for (Permission permission in _requiredPermissions) {
      if (await permission.isGranted == false) {
        PermissionStatus permissionStatus = await permission.request();
        assert(permissionStatus.isGranted, 'Permission ${permission.toString()} must be granted to use application');
      }
    }
  }
}
