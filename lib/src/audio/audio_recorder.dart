import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecorder {
  final List<Permission> _requiredPermissions = <Permission>[Permission.microphone];
  Record _record = Record();

  Future<void> startRecording(AudioSettingsModel audioSettingsModel) async {
    await _grantRequiredPermissions();
    bool recordingBool = await _record.isRecording();
    if (recordingBool == true) {
      await stopRecording();
    }
    await _record.start(
      path: await _getTemporaryPath(),
      encoder: AudioEncoder.wav,
      bitRate: audioSettingsModel.bitDepth * audioSettingsModel.sampleRate * audioSettingsModel.channels,
      samplingRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
  }

  Future<Uint8List> stopRecording() async {
    bool recordingBool = await _record.isRecording();
    if (recordingBool == false) {
      throw Exception('Recording is not started');
    }
    String? tempPath = await _record.stop();
    _record = Record();

    if (tempPath == null) {
      throw Exception('Cannot read output path');
    }

    File audioFile = File(tempPath);
    List<int> audioBytes = await audioFile.readAsBytes();
    await audioFile.delete();
    return Uint8List.fromList(audioBytes);
  }

  Future<void> _grantRequiredPermissions() async {
    for (Permission permission in _requiredPermissions) {
      if (await permission.isGranted == false) {
        PermissionStatus permissionStatus = await permission.request();
        assert(permissionStatus.isGranted, 'Permission ${permission.toString()} must be granted to use application');
      }
    }
  }

  Future<String> _getTemporaryPath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/temp.wav';
    return tempPath;
  }
}
