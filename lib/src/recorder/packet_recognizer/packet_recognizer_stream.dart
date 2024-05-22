import 'dart:async';

import 'package:mrumru/mrumru.dart';

class PacketRecognizerStream {
  final Completer<bool> _decodingCompleter = Completer<bool>();
  final PacketEventQueue _packetsQueue = PacketEventQueue();

  final AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();

  bool _recordingBool = false;
  int? _startOffset;

  PacketRecognizerStream();

  Stream<String> startDecoding(Stream<String> inc) async* {
    inc.listen((String msg) {
      IPacketRecognizerInputEvent event = IPacketRecognizerInputEvent.fromMsg(msg);
      print('Received message: ${event.runtimeType}');
      if (event is CancelDecodingEvent) {
        stopRecording();
      } else if (event is APacketRecognizerDataEvent) {
        addPacket(event);
      }
    });

    _recordingBool = true;
    while (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize) || _recordingBool) {
      IPacketRecognizerOutputEvent? event;
      if (_startOffset == null) {
        print('Attempting to find start offset...');
        event = await _tryFindStartOffset();
      } else {
        print('Attempting to process wave...');
        event = await _tryProcessWave();
      }

      if (event != null) {
        print('Yielding event: ${event.runtimeType}');
        yield event.toMsg();
      }
    }

    _decodingCompleter.complete(true);
    yield DecodingCompletedEvent().toMsg();
  }

  void addPacket(APacketRecognizerDataEvent packet) {
    print('Adding packet to queue: ${packet.runtimeType}');
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packet);
  }



  Future<void> stopRecording() async {
    _recordingBool = false;
    await _decodingCompleter.future;
  }

  Future<IPacketRecognizerOutputEvent?> _tryFindStartOffset() async {
    print('Trying to find start offset...');
    if (_packetsQueue.isLongerThan(audioSettingsModel.maxStartOffset)) {
      return _findStartOffset();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return null;
    }
  }

  Future<IPacketRecognizerOutputEvent> _findStartOffset() async {
    print('Finding start offset...');
    IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);

    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.maxStartOffset);
    print('Wave to process length: ${waveToProcess.length}');

    _startOffset = correlationCalculator.findBestIndex(waveToProcess, audioSettingsModel.startFrequencies);
    print('Found start offset: $_startOffset');

    if (_startOffset == null || _startOffset! < 0 || _startOffset! >= waveToProcess.length) {
      throw Exception('Invalid start offset found: $_startOffset');
    }

    List<double> remainingData = waveToProcess.sublist(_startOffset!);
    print('Remaining data length after start offset: ${remainingData.length}');
    _packetsQueue.push(RemainingPacketEvent(remainingData));
    AppLogger().log(message: 'Start offset found: $_startOffset', logLevel: LogLevel.debug);

    return StartOffsetFoundEvent(_startOffset!);
  }


  Future<IPacketRecognizerOutputEvent?> _tryProcessWave() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.sampleSize)) {
      return _processWave();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return null;
    }
  }

  Future<IPacketRecognizerOutputEvent> _processWave() async {
    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.sampleSize);
    print('Wave to process for frequency decoding length: ${waveToProcess.length}');
    List<DecodedFrequencyModel> frequencies = await _translateSampleToFrequency(waveToProcess);
    return FrequenciesDecodedEvent(frequencies);
  }


  Future<List<DecodedFrequencyModel>> _translateSampleToFrequency(List<double> sample) async {
    FrequencyCorrelationCalculator correlationCalculator = FrequencyCorrelationCalculator(audioSettingsModel: audioSettingsModel);
    List<DecodedFrequencyModel> decodedFrequencies = List<DecodedFrequencyModel>.generate(audioSettingsModel.chunksCount, (int chunkIndex) {
      int bestFrequency = correlationCalculator.findBestFrequency(sample, chunkIndex);
      return DecodedFrequencyModel(chunkFrequency: bestFrequency, chunkIndex: chunkIndex);
    });
    return decodedFrequencies;
  }
}