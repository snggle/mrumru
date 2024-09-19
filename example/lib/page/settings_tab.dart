import 'package:example/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:example/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:example/cubit/settings_tab_cubit/settings_tab_cubit.dart';
import 'package:example/cubit/settings_tab_cubit/settings_tab_state.dart';
import 'package:example/widgets/numeric_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsTab extends StatefulWidget {
  final SendTabCubit sendTabCubit;
  final ReceiveTabCubit receiveTabCubit;
  final SettingsTabCubit settingsTabCubit;

  const SettingsTab({
    required this.sendTabCubit,
    required this.receiveTabCubit,
    required this.settingsTabCubit,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SettingsTabCubit, SettingsTabState>(
        bloc: widget.settingsTabCubit,
        builder: (BuildContext context, SettingsTabState state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                NumericField(
                  fieldName: 'firstFrequency',
                  textController: widget.settingsTabCubit.firstFrequencyController,
                ),
                NumericField(
                  fieldName: 'baseFrequencyGap',
                  textController: widget.settingsTabCubit.baseFrequencyGapController,
                ),
                NumericField(
                  fieldName: 'bitsPerFrequency',
                  textController: widget.settingsTabCubit.bitsPerFrequencyController,
                ),
                NumericField(
                  fieldName: 'chunksCount',
                  textController: widget.settingsTabCubit.chunksCountController,
                ),
                const SizedBox(height: 32),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _resetToDefaults,
                      child: const Text('Reset to Defaults'),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.valuesChangedBool ? Colors.redAccent : null,
                      ),
                      child: const Text('Save Settings'),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _resetToDefaults() {
    widget.settingsTabCubit.resetToDefaults();
    _saveSettings();
  }

  void _saveSettings() {
    widget.receiveTabCubit.audioSettingsModel = widget.settingsTabCubit.getCurrentAudioSettingsModel();
    widget.sendTabCubit.audioSettingsModel = widget.settingsTabCubit.getCurrentAudioSettingsModel();
    widget.settingsTabCubit.updateInitialValuesAfterSave();
  }
}
