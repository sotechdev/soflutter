import 'dart:async';
import 'dart:core';

import 'package:soflutter/src/controllers/async_observer.dart';

import '../core/core.dart';
import '../exceptions/cancelled_exception.dart';
import 'async_state.dart';

class AsyncController<T> with Logging {
  final _stateController = StreamController<AsyncState>.broadcast();
  final _dataController = StreamController<T?>.broadcast();
  final _errorController = StreamController<Exception?>.broadcast();

  AsyncState _state = AsyncState.initial;
  T? _data;
  Exception? _error;
  StackTrace? _stackTrace;
  CancellationTokenSource? _currentTokenSource;

  final _observers = observers;

  AsyncController() {
    logger.verbose('[AsyncController] Created for type ${T.toString()}');
  }

  Future execute(
    Future<T> Function(CancellationToken token) operation, {
    CancellationToken? token,
    bool throwOnError = false,
    Duration? timeout,
  }) async {
    logger.verbose('[AsyncController] Starting async operation');

    if (_state == AsyncState.loading) {
      logger.verbose('[AsyncController] Cancelling previous operation');
      _currentTokenSource?.cancel();
    }

    final timeOutToken = CancellationTokenSource();
    if (timeout != null) {
      timeOutToken.cancelAfter(timeout);
    }

    final effectiveToken = token != null
        ? CancellationTokenSource.createLinkedTokenSource(
            [token, timeOutToken.token]).token
        : timeOutToken.token;

    _currentTokenSource = timeOutToken;
    _updateState(AsyncState.loading);

    try {
      logger.verbose('[AsyncController] Executing operation');
      final result = await Future.any([
        operation(effectiveToken),
        effectiveToken.onCancelled.then((_) => throw CancelledException()),
      ]);

      logger.verbose('[AsyncController] Operation completed successfully');
      _updateState(AsyncState.success, data: result);
    } on CancelledException {
      logger.verbose('[AsyncController] Operation was cancelled');
      _updateState(AsyncState.cancelled);
      if (throwOnError) throw CancelledException();
    } catch (e, st) {
      logger.error('[AsyncController] Operation failed',
          error: e, stackTrace: st);
      final exception = e is Exception ? e : Exception('Operation error: $e');
      _updateState(AsyncState.error, error: exception, stackTrace: st);
      if (throwOnError) rethrow;
    } finally {
      if (_currentTokenSource?.token == effectiveToken) {
        _currentTokenSource?.dispose();
        _currentTokenSource = null;
      }
    }
  }

  void _updateState(
    AsyncState newState, {
    T? data,
    Exception? error,
    StackTrace? stackTrace,
  }) {
    logger.verbose('[AsyncController] State change: $_state → $newState');
    _state = newState;
    _data = data;
    _error = error;
    _stackTrace = stackTrace;

    _stateController.add(_state);
    _dataController.add(_data);

    if (_state == AsyncState.error) {
      _errorController.add(_error);
    }

    _notifyObservers();
  }

  StreamSubscription<AsyncState> listen({
    void Function(AsyncState state)? onState,
    void Function(T? data)? onData,
    void Function(Exception? error)? onError,
  }) {
    final subscritions = <StreamSubscription>[];

    if (onState != null) {
      subscritions.add(stateStream.listen(onState));
    }
    if (onData != null) {
      subscritions.add(dataStream.listen(onData));
    }
    if (onError != null) {
      subscritions.add(errorStream.listen(onError));
    }
    return MultiStreamSubscription<AsyncState>(subscritions)
      ..onData((state) {})
      ..onError((error) {});
  }

  void addObserver(AsyncObserver<T> observer) {
    _observers.add(observer);
  }

  void removeObserver(AsyncObserver<T> observer) {
    _observers.remove(observer);
  }

  void _notifyObservers() {
    for (final observer in _observers) {
      observer.onState(_state);
      observer.onData(_data);
      if (_state == AsyncState.error) {
        observer.onError(_error);
      }
    }
  }

  void cancel() {
    if (_state == AsyncState.loading) {
      logger.verbose('[AsyncController] Manually cancelling current operation');
      _currentTokenSource!.cancel();
    }
  }

  void reset() {
    logger.verbose('[AsyncController] Resetting controller');
    _updateState(AsyncState.initial);
    _currentTokenSource?.dispose();
    _currentTokenSource = null;
  }

  void dispose() {
    logger.verbose('[AsyncController] Disposing controller');
    cancel();
    _stateController.close();
    _dataController.close();
    _errorController.close();
    _observers.clear();
    _currentTokenSource?.dispose();
  }

  Stream<AsyncState> get stateStream => _stateController.stream;
  Stream<T?> get dataStream => _dataController.stream;
  Stream<Exception?> get errorStream => _errorController.stream;

  AsyncState get state => _state;
  T? get currentData => _data;
  Exception? get currentError => _error;
  StackTrace? get currentStackTrace => _stackTrace;
}
