import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';
import 'package:example/cubit/audio_emission_cubit/audio_emission_cubit.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_listening_state.dart';
import 'package:example/cubit/audio_emission_cubit/states/audio_emission_result_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiveTab extends StatefulWidget {
  const ReceiveTab({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveTabState();
}

class _ReceiveTabState extends State<ReceiveTab> {
  final AudioEmissionCubit audioEmissionCubit = AudioEmissionCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioEmissionCubit, AAudioEmissionState>(
      bloc: audioEmissionCubit,
      builder: (BuildContext context, AAudioEmissionState state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
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
                  width: double.infinity,
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
        );
      },
    );
  }
}
