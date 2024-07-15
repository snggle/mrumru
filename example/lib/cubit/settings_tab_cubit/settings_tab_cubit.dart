import 'package:example/cubit/settings_tab_cubit/settings_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class SettingsTabCubit extends Cubit<SettingsTabState> {
  final TextEditingController firstFrequencyController = TextEditingController();
  final TextEditingController baseFrequencyGapController = TextEditingController();
  final TextEditingController channelsController = TextEditingController();
  final TextEditingController bitsPerFrequencyController = TextEditingController();
  final TextEditingController chunksCountController = TextEditingController();

  SettingsTabCubit() : super(SettingsTabState()) {
    resetToDefaults();
  }

  void resetToDefaults() {
    AudioSettingsModel currentAudioSettingsModel = AudioSettingsModel.withDefaults();

    firstFrequencyController.text = currentAudioSettingsModel.firstFrequency.toString();
    baseFrequencyGapController.text = currentAudioSettingsModel.baseFrequencyGap.toString();
    channelsController.text = currentAudioSettingsModel.channels.toString();
    bitsPerFrequencyController.text = currentAudioSettingsModel.bitsPerFrequency.toString();
    chunksCountController.text = currentAudioSettingsModel.chunksCount.toString();
  }

  AudioSettingsModel getCurrentAudioSettingsModel() {
    return AudioSettingsModel.withDefaults().copyWith(
      firstFrequency: int.tryParse(firstFrequencyController.text) ?? 0,
      baseFrequencyGap: int.tryParse(baseFrequencyGapController.text) ?? 0,
      channels: int.tryParse(channelsController.text) ?? 0,
      bitsPerFrequency: int.tryParse(bitsPerFrequencyController.text) ?? 0,
      chunksCount: int.tryParse(chunksCountController.text) ?? 0,
    );
  }
}
