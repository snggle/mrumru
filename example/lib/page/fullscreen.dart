import 'package:auto_route/annotations.dart';
import 'package:example/cubit/audio_emission_cubit/audio_emission_cubit.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FullscreenPage extends StatefulWidget {
  const FullscreenPage({super.key});

  @override
  State<StatefulWidget> createState() => FullscreenPageState();
}

class FullscreenPageState extends State<FullscreenPage> {
  final AudioEmissionCubit audioEmissionCubit = AudioEmissionCubit();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('fullscreen'),
    );
  }
}
