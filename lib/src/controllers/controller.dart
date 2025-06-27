import 'dart:async';

import '../core/core.dart';

class Controller<T> with Logging {
  final _controller = StreamController<T>.broadcast();
  T _state;

  Controller(this._state) {
    logger.verbose('Controller created with initial state: $_state');
  }

  Stream<T> get stream => _controller.stream;
  T get currentState => _state;

  void updateState(T newState) {
    logger.verbose('Updating state: $_state → $newState');
    _state = newState;
    _controller.add(_state);
  }

  void dispose() {
    logger.verbose('Disposing controller');
    _controller.close();
  }
}