import 'package:example/cubit/receive_tab_cubit/a_receive_tab_state.dart';

class ReceiveTabResultState extends AReceiveTabState {
  final String decodedMessage;

  ReceiveTabResultState({required this.decodedMessage});

  @override
  List<Object?> get props => <Object>[decodedMessage];
}
