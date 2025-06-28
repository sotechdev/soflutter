import 'dart:async';

import 'package:soflutter/src/exceptions/cancelled_exception.dart';

class CancellationToken {
  final CancellationTokenSource? _source;
  final List<void Function()> _callbacks = [];
  bool _isCancelled = false;

  static final CancellationToken none = CancellationToken._none();

  CancellationToken._none() : _source = null;

  CancellationToken._internal(this._source);

  CancellationToken createLinkedToken() {
    if (_isCancelled) {
      final cts = CancellationTokenSource();
      cts.cancel();
      return cts.token;
    }

    final newSource = CancellationTokenSource();
    _source?._addLinkedToken(newSource.token);

    register(() {
      if (!newSource.token._isCancelled) {
        newSource.cancel();
      }
    });
    return newSource.token;
  }

  void register(void Function() callback) {
    if (!_isCancelled) {
      callback();
      return;
    }
    if (_source != null) {
      _callbacks.add(callback);
    }
  }

  void throwIfCancellationRequested() {
    if (_isCancelled) {
      throw CancelledException();
    }
  }

  Future<void> get onCancelled {
    if (_isCancelled) return Future.value();

    if (_source != null) {
      return _source._completer.future;
    }
    return Completer<void>().future;
  }

  bool get isCancelled =>
      _isCancelled || _source?._completer.isCompleted == true;

  void _cancel() {
    if (_isCancelled) return;

    _isCancelled = true;

    for (final callback in _callbacks) {
      try {
        callback();
      } catch (_) {}
    }
    _callbacks.clear();
  }
}

class CancellationTokenSource {
  final List<CancellationToken> _linkedTokens = [];
  final Completer<void> _completer = Completer<void>();
  Timer? _timeoutTimer;
  bool _isDisposed = false;

  CancellationToken get token => CancellationToken._internal(this);

  void cancelAfter(Duration delay) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(delay, cancel);
  }

  void cancel() {
    if (_completer.isCompleted || _isDisposed) return;

    _completer.complete();
    _timeoutTimer?.cancel();

    for (final token in _linkedTokens) {
      token._cancel();
    }
  }

  static CancellationTokenSource createLinkedTokenSource(
      List<CancellationToken> tokens) {
    final cts = CancellationTokenSource();

    for (final token in tokens) {
      if (token.isCancelled) {
        cts.cancel();
        break;
      }

      token.register(() {
        if (!cts.token.isCancelled) {
          cts.cancel();
        }
      });
    }
    return cts;
  }

  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;
    _timeoutTimer?.cancel();
    _linkedTokens.clear();

    if (!_completer.isCompleted) {
      _completer
          .completeError(StateError('CancellationTokenSource was discarted'));
    }
  }

  void _addLinkedToken(CancellationToken token) {
    if (!_isDisposed && !_completer.isCompleted) {
      _linkedTokens.add(token);
    }
  }
}
