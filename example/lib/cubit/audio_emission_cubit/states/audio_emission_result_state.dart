import 'package:example/cubit/audio_emission_cubit/a_audio_emission_state.dart';

class AudioEmissionResultState extends AAudioEmissionState {
  final String decodedMessage;

  AudioEmissionResultState({required this.decodedMessage});

  @override
  List<Object?> get props => <Object>[decodedMessage];
}
