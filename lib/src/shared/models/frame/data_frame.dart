import 'dart:typed_data';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

class DataFrame extends AFrameBase {
  final Uint16 _frameIndex;
  final Uint16 _frameLength;
  final UintDynamic _data;
  final Uint16 _frameChecksum;

  DataFrame({
    required Uint16 frameIndex,
    required Uint16 frameLength,
    required UintDynamic data,
    required Uint16 frameChecksum,
  })  : _frameIndex = frameIndex,
        _frameLength = frameLength,
        _data = data,
        _frameChecksum = frameChecksum;

  factory DataFrame.fromValues({
    required int frameIndex,
    required Uint8List data,
  }) {
    Uint16 uint16frameIndex = Uint16.fromInt(frameIndex);
    Uint16 uint16frameLength = Uint16.fromInt(data.length);
    UintDynamic uintDynamicData = UintDynamic(data, data.length * 8);

    Uint8List checksumData = Uint8List.fromList(<int>[...uint16frameIndex.bytes, ...uint16frameLength.bytes, ...data]);
    Uint8List checksum = CryptoUtils.calcChecksumFromBytes(checksumData);

    Uint16 uint16frameChecksum = Uint16(checksum.sublist(0, 16));

    return DataFrame(
      frameIndex: uint16frameIndex,
      frameLength: uint16frameLength,
      data: uintDynamicData,
      frameChecksum: uint16frameChecksum,
    );
  }

  static FrameReminder<DataFrame> fromBytes(Uint8List bytes) {
    UintReminder<Uint16> frameIndex = Uint16.fromBytes(bytes);
    UintReminder<Uint16> frameLength = Uint16.fromBytes(frameIndex.reminder);
    UintReminder<UintDynamic> data = UintDynamic.fromBytes(frameLength.reminder, frameLength.value.toInt());
    UintReminder<Uint16> frameChecksum = Uint16.fromBytes(data.reminder);

    return FrameReminder<DataFrame>(
      value: DataFrame(
        frameIndex: frameIndex.value,
        frameLength: frameLength.value,
        frameChecksum: frameChecksum.value,
        data: data.value,
      ),
      reminder: frameChecksum.reminder,
    );
  }

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      ..._frameIndex.bytes,
      ..._frameLength.bytes,
      ..._data.bytes,
      ..._frameChecksum.bytes,
    ]);
  }

  @override
  Uint16 get frameIndex => _frameIndex;

  @override
  Uint16 get frameLength => _frameLength;

  UintDynamic get data => _data;

  @override
  Uint16 get frameChecksum => _frameChecksum;

  @override
  List<Object?> get props => <Object?>[_frameIndex, _frameLength, _data, _frameChecksum];
}
