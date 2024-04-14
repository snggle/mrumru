import 'dart:async';
import 'dart:convert';

import 'package:mrumru/mrumru.dart';
import 'package:stream_isolate/stream_isolate.dart';

typedef DecodingCompletedCallback = void Function();
typedef FrequenciesDecidedCallback = void Function(List<DecodedFrequencyModel> frequencies);
typedef StartOffsetFoundCallback = void Function(int startOffset);

class PacketRecognizer {
  final AudioSettingsModel audioSettingsModel;
  final DecodingCompletedCallback? onDecodingCompleted;
  final FrequenciesDecidedCallback? onFrequenciesDecoded;
  final StartOffsetFoundCallback? onStartOffsetFound;

  BidirectionalStreamIsolate<String, String, void>? streamIsolate;

  PacketRecognizer({
    required this.audioSettingsModel,
    this.onDecodingCompleted,
    this.onFrequenciesDecoded,
    this.onStartOffsetFound,
  });

  Future<void> start() async {
    streamIsolate = await BidirectionalStreamIsolate.spawn((Stream<String> messageStream) {
      PacketRecognizerStream packetRecognizerStream = PacketRecognizerStream();
      return packetRecognizerStream.startDecoding(messageStream);
    });
    await for (String msg in streamIsolate!.stream) {
      IPacketRecognizerOutputEvent event = IPacketRecognizerOutputEvent.fromMsg(msg);
      print(event.runtimeType);
      switch (event.runtimeType) {
        case DecodingCompletedEvent:
          onDecodingCompleted?.call();
          break;
        case FrequenciesDecodedEvent:
          FrequenciesDecodedEvent frequenciesDecodedEvent = event as FrequenciesDecodedEvent;
          onFrequenciesDecoded?.call(frequenciesDecodedEvent.frequencies);
          break;
        case StartOffsetFoundEvent:
          StartOffsetFoundEvent startOffsetFoundEvent = event as StartOffsetFoundEvent;
          onStartOffsetFound?.call(startOffsetFoundEvent.startOffset);
          break;
      }
    }
  }

  Future<void> addPacket(List<double> packet) async {
    streamIsolate?.send(ReceivedPacketEvent(packet).toMsg());
  }

  Future<void> stop() async {
    print('Should stop');
    streamIsolate?.send(CancelDecodingEvent().toMsg());
  }
}

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
      print(event.runtimeType);
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
        event = await _tryFindStartOffset();
      } else {
        event = await _tryProcessWave();
      }

      if (event != null) {
        yield event.toMsg();
      }
    }

    _decodingCompleter.complete(true);
    yield DecodingCompletedEvent().toMsg();
  }

  void addPacket(APacketRecognizerDataEvent packet) {
    AppLogger().log(message: 'Received packet', logLevel: LogLevel.debug);
    _packetsQueue.push(packet);
  }

  Future<void> stopRecording() async {
    _recordingBool = false;
    await _decodingCompleter.future;
  }

  Future<IPacketRecognizerOutputEvent?> _tryFindStartOffset() async {
    if (_packetsQueue.isLongerThan(audioSettingsModel.maxStartOffset)) {
      return _findStartOffset();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return null;
    }
  }

  Future<IPacketRecognizerOutputEvent> _findStartOffset() async {
    IndexCorrelationCalculator correlationCalculator = IndexCorrelationCalculator(audioSettingsModel: audioSettingsModel);

    List<double> waveToProcess = await _packetsQueue.readWave(audioSettingsModel.maxStartOffset);
    _startOffset = correlationCalculator.findBestIndex(waveToProcess, audioSettingsModel.startFrequencies);

    List<double> remainingData = waveToProcess.sublist(_startOffset!);
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
