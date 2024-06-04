import 'package:equatable/equatable.dart';

class ChunkFrequencyCorrelationModel extends Equatable {
  final int chunkFrequency;
  final double correlation;

  const ChunkFrequencyCorrelationModel({required this.chunkFrequency, required this.correlation});

  @override
  List<Object?> get props => <Object?>[chunkFrequency, correlation];
}
