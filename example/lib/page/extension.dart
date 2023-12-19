import 'dart:html';

import 'package:auto_route/annotations.dart';
import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';
import 'package:example/cubit/audio_emission_cubit/audio_emission_cubit.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_listening_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_result_state.dart';
import 'package:example/widgets/numeric_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ExtensionPage extends StatefulWidget {
  const ExtensionPage({super.key});

  @override
  State<StatefulWidget> createState() => ExtensionPageState();
}

class ExtensionPageState extends State<ExtensionPage> {
  final AudioEmissionCubit audioEmissionCubit = AudioEmissionCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioEmissionCubit, AAudioEmissionState>(
      bloc: audioEmissionCubit,
      builder: (BuildContext context, AAudioEmissionState state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openWindow,
                        child: const Text('Big Screen Mode'),
                      ),
                    ),
                    const SizedBox(width: 18),
                  ],
                ),
                const SizedBox(height: 16),
                NumericField(
                  fieldName: 'baseFrequency',
                  onFieldSubmitted: (num value) => audioEmissionCubit.baseFrequency = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.baseFrequency.toString()),
                ),
                NumericField(
                  fieldName: 'frequencyGap',
                  onFieldSubmitted: (num value) => audioEmissionCubit.frequencyGap = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.frequencyGap.toString()),
                ),
                NumericField(
                  fieldName: 'bitDepth',
                  onFieldSubmitted: (num value) => audioEmissionCubit.bitDepth = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.bitDepth.toString()),
                ),
                NumericField(
                  fieldName: 'channels',
                  onFieldSubmitted: (num value) => audioEmissionCubit.channels = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.channels.toString()),
                ),
                NumericField(
                  fieldName: 'bitsPerFrequency',
                  onFieldSubmitted: (num value) => audioEmissionCubit.bitsPerFrequency = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.bitsPerFrequency.toString()),
                ),
                NumericField(
                  fieldName: 'chunksCount',
                  onFieldSubmitted: (num value) => audioEmissionCubit.chunksCount = value.toInt(),
                  textController: TextEditingController(text: audioEmissionCubit.audioSettingsModel.chunksCount.toString()),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'message'),
                  controller: audioEmissionCubit.messageTextController,
                ),
                const SizedBox(height: 16),
                const Text('Emit audio'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: audioEmissionCubit.playSound,
                        child: const Text('Start emission'),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: audioEmissionCubit.stopSound,
                        child: const Text('Stop emission'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Listen'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is AudioEmissionListeningState ? null : audioEmissionCubit.startRecording,
                        child: const Text('Start recording'),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is AudioEmissionListeningState ? audioEmissionCubit.stopRecording : null,
                        child: const Text('Stop recording'),
                      ),
                    ),
                  ],
                ),
                if (state is AudioEmissionResultState)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      state.decodedMessage,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openWindow() {
    window.open('index.html', '_blank');
  }
}
