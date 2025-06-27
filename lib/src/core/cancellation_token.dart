import 'dart:async';

class CancellationToken {
  final Completer<void> _completer = Completer<void>();

  Future<void> get onCancelled => _completer.future;

  void cancel() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  bool get isCancelled => _completer.isCompleted;
}