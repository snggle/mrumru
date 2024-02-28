import 'package:equatable/equatable.dart';

class WindowCorrelationModel extends Equatable {
  final int index;
  final double correlation;

  const WindowCorrelationModel({required this.index, required this.correlation});

  @override
  List<Object> get props => <Object>[index, correlation];
}
