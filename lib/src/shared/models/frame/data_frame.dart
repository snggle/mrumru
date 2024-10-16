import 'dart:typed_data';
import 'package:mrumru/src/shared/models/frame/a_base_frame.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class representing a data frame in the protocol.
class DataFrame extends ABaseFrame {
  final Uint16 _frameIndex;
  final Uint16 _frameLength;
  final UintDynamic _data;
  final Uint16 _frameChecksum;

  /// Creates an instance of [DataFrame] with the given values.
  DataFrame({
    required Uint16 frameIndex,
    required Uint16 frameLength,
    required UintDynamic data,
    required Uint16 frameChecksum,
  })  : _frameIndex = frameIndex,
        _frameLength = frameLength,
        _data = data,
        _frameChecksum = frameChecksum;

  /// Creates an instance of [DataFrame] from given values.
  factory DataFrame.fromValues({
    required int frameIndex,
    required Uint8List data,
  }) {
    Uint16 uint16FrameIndex = Uint16.fromInt(frameIndex);
    Uint16 uint16FrameLength = Uint16.fromInt(data.length);
    UintDynamic uintDynamicData = UintDynamic(data, data.length * BinaryUtils.bitsInByte);

    Uint8List checksumData = Uint8List.fromList(<int>[
      ...uint16FrameIndex.bytes,
      ...uint16FrameLength.bytes,
      ...uintDynamicData.bytes,
    ]);
    Uint8List checksumFull = CryptoUtils.calcChecksum(bytes: checksumData);
    Uint16 uint16FrameChecksum = Uint16(checksumFull.sublist(0, 2));

    return DataFrame(
      frameIndex: uint16FrameIndex,
      frameLength: uint16FrameLength,
      data: uintDynamicData,
      frameChecksum: uint16FrameChecksum,
    );
  }

  /// Creates a [DataFrame] from a byte array.
  static FrameReminder<DataFrame> fromBytes(Uint8List bytes) {
    UintReminder<Uint16> frameIndex = Uint16.fromBytes(bytes);
    UintReminder<Uint16> frameLength = Uint16.fromBytes(frameIndex.reminder);

    int dataBitsSize = frameLength.value.toInt() * BinaryUtils.bitsInByte;
    UintReminder<UintDynamic> data = UintDynamic.fromBytes(frameLength.reminder, dataBitsSize);

    UintReminder<Uint16> frameChecksum = Uint16.fromBytes(data.reminder);

    return FrameReminder<DataFrame>(
      value: DataFrame(
        frameIndex: frameIndex.value,
        frameLength: frameLength.value,
        data: data.value,
        frameChecksum: frameChecksum.value,
      ),
      reminder: frameChecksum.reminder,
    );
  }

  /// Converts the [DataFrame] into a byte array.
  @override
  Uint8List toBytes() {
    return Uint8List.fromList(<int>[
      ..._frameIndex.bytes,
      ..._frameLength.bytes,
      ..._data.bytes,
      ..._frameChecksum.bytes,
    ]);
  }

  /// Returns the frame index.
  @override
  Uint16 get frameIndex => _frameIndex;

  /// Returns the frame length.
  @override
  Uint16 get frameLength => _frameLength;

  /// Returns the frame checksum.
  @override
  Uint16 get frameChecksum => _frameChecksum;

  /// Returns the frame data.
  UintDynamic get data => _data;

  @override
  List<Object?> get props => <Object?>[
        _frameIndex,
        _frameLength,
        _data,
        _frameChecksum,
      ];
}
