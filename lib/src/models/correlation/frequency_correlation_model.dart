import 'package:equatable/equatable.dart';

class FrequencyCorrelationModel extends Equatable {
  final int frequency;
  final double correlation;

  const FrequencyCorrelationModel({required this.frequency, required this.correlation});

  @override
  List<Object?> get props => <Object?>[frequency, correlation];
}
