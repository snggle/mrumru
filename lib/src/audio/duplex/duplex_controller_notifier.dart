typedef OnMessageEmittedCallback = void Function(String message);
typedef OnMessageReceivedCallback = void Function(String message);

/// A class to notify about various events in the duplex controller.
class DuplexControllerNotifier {
  /// Callback for when a message is emitted.
  final OnMessageEmittedCallback? onEmitMessage;

  /// Callback for when a message is received.
  final OnMessageReceivedCallback? onMessageReceived;

  /// Creates an instance of [DuplexControllerNotifier].
  DuplexControllerNotifier({
    this.onEmitMessage,
    this.onMessageReceived,
  });
}
