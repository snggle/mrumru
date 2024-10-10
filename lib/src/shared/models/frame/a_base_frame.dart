import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';

abstract class ABaseFrame with EquatableMixin {
  Uint16 get frameIndex;

  Uint16 get frameLength;

  Uint16 get frameChecksum;

  List<int> toBytes();
}
