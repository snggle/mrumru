import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mrumru/src/audio/generator/sink/i_audio_sink.dart';
import 'package:wav/wav.dart';

/// This class provides functionalities to initialize an audio file, push
/// audio samples to it, notify when all samples are created, and kill the process
/// by deleting the file and clearing the samples.
class AudioFileSink implements IAudioSink {
  /// A completer to notify when the file is created.
  final Completer<void> _fileCompleter = Completer<void>();

  /// A list to hold the audio samples.
  final List<Float32List> _samples = <Float32List>[];

  /// The file to which the audio data will be written.
  final File _file;

  /// The sample rate of the audio data.
  int? _sampleRate;

  /// Creates an instance of [AudioFileSink].
  AudioFileSink(this._file);

  /// Initializes the audio sink with the given [transferDuration] and [sampleRate].
  @override
  Future<void> init(Duration transferDuration, int sampleRate) async {
    _sampleRate = sampleRate;
    await _file.create();
  }

  /// This method adds the given [sample] to the list of samples.
  @override
  Future<void> pushSample(Float32List sample) async {
    _samples.add(sample);
  }

  /// Notifies that all samples have been created and writes them to the file.
  @override
  Future<void> notifyAllSamplesCreated() async {
    Float64List mergedSamples = Float64List.fromList(_samples.expand((Float32List element) => element).toList());
    await Wav(<Float64List>[mergedSamples], _sampleRate!, WavFormat.float32).writeFile(_file.path);
    _notifySinkCompleted();
  }

  /// Kills the audio sink process by deleting the file and clearing the samples.
  @override
  Future<void> kill() async {
    await _file.delete();
    _samples.clear();
    _notifySinkCompleted();
  }

  /// Returns asynchronous method which is completed after file is created
  @override
  Future<void> get future => _fileCompleter.future;

  /// Notifies that the file has been created.
  void _notifySinkCompleted() {
    if (_fileCompleter.isCompleted == false) {
      _fileCompleter.complete();
    }
  }
}
