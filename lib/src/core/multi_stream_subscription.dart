import 'dart:async';

class MultiStreamSubscription<T> implements StreamSubscription<T> {
  final List<StreamSubscription> _subscriptions;
  bool _isCanceled = false;
  bool _isPaused = false;
  Future<void>? _resumeSignal;
  void Function()? _onDoneCallback;

  MultiStreamSubscription(this._subscriptions);

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    return Future.value(futureValue);
  }

  @override
  Future<void> cancel() async {
    if (_isCanceled) return;
    _isCanceled = true;

    for (final sub in _subscriptions){
      await sub.cancel();
    }

    _onDoneCallback?.call();
  }

  @override
  bool get isPaused => _isPaused;

  @override
  void onData(void Function(T data)? handleData) {
    for (final sub in _subscriptions){
      sub.onData((data){
        if (!_isPaused && !_isCanceled){
          handleData?.call(data as T);
        }
      });
    }
  }

  @override
  void onDone(void Function()? handleDone) {
    _onDoneCallback = handleDone;
    for (final sub in _subscriptions){
      sub.onDone(() {
        if (!_isCanceled && _subscriptions.every((s) => s.isPaused)){
          handleDone?.call();
        }
      });
    }
  }

  @override
  void onError(Function? handleError) {
    for (final sub in _subscriptions){
      sub.onError((error){
        if (!_isPaused && !_isCanceled){
          handleError?.call(error);
        }
      });
    }
  }

  @override
  void pause([Future<void>? resumeSignal]) {
    if (_isPaused || _isCanceled) return;

    _isPaused = true;
    _resumeSignal = resumeSignal;

    for (final sub in _subscriptions){
      sub.pause(resumeSignal?.whenComplete(() {
        if (_resumeSignal == resumeSignal){
          resume();
        }
      }));
    }
  }

  @override
  void resume() {
    if (!_isPaused || _isCanceled) return;

    _isPaused = false;
    _resumeSignal = null;

    for (var sub in _subscriptions) {
      sub.resume();
    }
  }

}