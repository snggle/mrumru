import 'package:equatable/equatable.dart';

class DuplexTabState extends Equatable {
  bool processingBool;

  DuplexTabState({required this.processingBool});

  @override
  List<Object> get props => <Object>[processingBool];
}
