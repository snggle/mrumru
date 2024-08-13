import 'package:equatable/equatable.dart';

class DuplexTabState extends Equatable {
  final bool processingBool;

  const DuplexTabState({required this.processingBool});

  @override
  List<Object> get props => <Object>[processingBool];
}
