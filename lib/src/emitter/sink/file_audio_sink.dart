import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:wav/wav.dart';

class FileAudioSink implements IAudioSink {
  final File file;
  List<Float32List> samples = <Float32List>[];
  int? sampleRate;

  FileAudioSink(this.file);

  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    this.sampleRate = sampleRate;
    await file.create();
  }

  @override
  Future<void> pushSample(Float32List sample) async {
    samples.add(sample);
  }

  @override
  Future<void> finish() async {
    Float64List mergedSamples = Float64List.fromList(samples.expand((Float32List element) => element).toList());
    Wav(<Float64List>[mergedSamples], sampleRate!, WavFormat.float32).write();
  }
}
