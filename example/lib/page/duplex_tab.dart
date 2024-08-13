import 'package:example/cubit/duplex_tab_cubit/a_duplex_tab_state.dart';
import 'package:example/cubit/duplex_tab_cubit/duplex_tab_cubit.dart';
import 'package:example/cubit/duplex_tab_cubit/states/duplex_tab_emission_state.dart';
import 'package:example/cubit/duplex_tab_cubit/states/duplex_tab_recording_state.dart';
import 'package:example/widgets/settings_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DuplexTab extends StatefulWidget {
  final DuplexTabCubit duplexTabCubit;

  const DuplexTab({required this.duplexTabCubit, super.key});

  @override
  State<StatefulWidget> createState() => _DuplexTabState();
}

class _DuplexTabState extends State<DuplexTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<DuplexTabCubit, ADuplexTabState>(
        bloc: widget.duplexTabCubit,
        builder: (BuildContext context, ADuplexTabState state) {
          bool isProcessingBool = state is DuplexTabEmissionState || state is DuplexTabRecordingState;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget.duplexTabCubit.sendingTextController,
                  enabled: isProcessingBool == false,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Enter a message',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.duplexTabCubit.sendingTextController,
                  builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                    return Row(
                      children: <Widget>[
                        InkWell(
                          onTap: isProcessingBool ? null : widget.duplexTabCubit.sendingTextController.clear,
                          child: const Text('Clear', style: TextStyle(color: Colors.blue)),
                        ),
                        const Spacer(),
                        Text('Message length: ${textEditingValue.text.length}'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Opacity(
                        opacity: isProcessingBool == false ? 1.0 : 0.5,
                        child: OutlinedButton(
                          onPressed: isProcessingBool == false ? () => widget.duplexTabCubit.send() : null,
                          child: const Text('Start Emitting', style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: !isProcessingBool ? 1.0 : 0.5,
                        child: OutlinedButton(
                          onPressed: isProcessingBool == false ? () => widget.duplexTabCubit.receive() : null,
                          child: const Text('Start Listening', style: TextStyle(color: Colors.green)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: isProcessingBool ? 1.0 : 0.5,
                        child: OutlinedButton(
                          onPressed: isProcessingBool ? widget.duplexTabCubit.stopProcess : null,
                          child: const Text('Stop', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SettingsPreview(audioSettingsModel: widget.duplexTabCubit.audioSettingsModel),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: widget.duplexTabCubit.messageTextController,
                  readOnly: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Process History',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
