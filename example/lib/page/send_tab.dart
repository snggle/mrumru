import 'package:example/cubit/audio_emission_cubit/audio_emission_cubit.dart';
import 'package:example/page/predefined_messages.dart';
import 'package:flutter/material.dart';

class SendTab extends StatefulWidget {
  const SendTab({super.key});

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  final AudioEmissionCubit audioEmissionCubit = AudioEmissionCubit();

  final TextEditingController controller = TextEditingController();
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          TextFormField(
            controller: controller,
            enabled: disabled == false,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Enter a message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue textEditingValue, _) {
              return Row(
                children: <Widget>[
                  InkWell(
                    onTap: disabled ? null : controller.clear,
                    child: const Text('Clear', style: TextStyle(color: Colors.blue)),
                  ),
                  const Spacer(),
                  Text('Message length: ${textEditingValue.text.length}'),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          const Text('Or use a predefined one:'),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: disabled ? null : () => controller.text = PredefinedMessages.loremIpsum,
                  child: const Text('Lorem Ipsum'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: disabled ? null :  () => controller.text = PredefinedMessages.humanReadableAscii,
                  child: const Text('ASCII'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            children: <Widget>[
              if( disabled == false )
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      disabled = true;
                    });
                    audioEmissionCubit.playSound(controller.text);
                  },
                  child: const Text('Emit message', style: TextStyle(color: Colors.blue)),
                ),
              )
              else
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    audioEmissionCubit.stopSound();
                    setState(() {
                      disabled = false;
                    });
                  },
                  child: const Text('Stop emission', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
