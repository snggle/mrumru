import 'package:example/cubit/settings_tab_cubit/settings_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class SettingsTabCubit extends Cubit<SettingsTabState> {
  final TextEditingController firstFrequencyController = TextEditingController();
  final TextEditingController baseFrequencyGapController = TextEditingController();
  final TextEditingController bitsPerFrequencyController = TextEditingController();
  final TextEditingController chunksCountController = TextEditingController();

  late AudioSettingsModel actualAudioSettingsModel;

  SettingsTabCubit() : super(const SettingsTabState(valuesChangedBool: false)) {
    firstFrequencyController.addListener(_handleTextFieldUpdated);
    baseFrequencyGapController.addListener(_handleTextFieldUpdated);
    bitsPerFrequencyController.addListener(_handleTextFieldUpdated);
    chunksCountController.addListener(_handleTextFieldUpdated);

    resetToDefaults();
  }

  void resetToDefaults() {
    actualAudioSettingsModel = AudioSettingsModel.withDefaults();

    firstFrequencyController.text = actualAudioSettingsModel.firstFrequency.toString();
    baseFrequencyGapController.text = actualAudioSettingsModel.baseFrequencyGap.toString();
    bitsPerFrequencyController.text = actualAudioSettingsModel.bitsPerFrequency.toString();
    chunksCountController.text = actualAudioSettingsModel.chunksCount.toString();
  }

  void updateInitialValuesAfterSave() {
    actualAudioSettingsModel = getCurrentAudioSettingsModel();
    emit(const SettingsTabState(valuesChangedBool: false));
  }

  AudioSettingsModel getCurrentAudioSettingsModel() {
    return AudioSettingsModel.withDefaults().copyWith(
      firstFrequency: int.tryParse(firstFrequencyController.text) ?? 0,
      baseFrequencyGap: int.tryParse(baseFrequencyGapController.text) ?? 0,
      bitsPerFrequency: int.tryParse(bitsPerFrequencyController.text) ?? 0,
      chunksCount: int.tryParse(chunksCountController.text) ?? 0,
    );
  }

  void _handleTextFieldUpdated() {
    emit(SettingsTabState(valuesChangedBool: _isValueChanged()));
  }

  bool _isValueChanged() {
    AudioSettingsModel currentSettingsModel = getCurrentAudioSettingsModel();
    return currentSettingsModel != actualAudioSettingsModel;
  }
}
