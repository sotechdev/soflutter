import 'dart:async';
import 'dart:core';

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
  CancellationToken? _currentToken;

  AsyncController() {
    logger.verbose('[AsyncController] Created for type ${T.toString()}');
  }

  Future execute(
    Future<T> Function(CancellationToken token) operation, {
    CancellationToken? token,
        bool throwOnError = false,
  }) async {
    logger.verbose('[AsyncController] Starting async operation');

    if (_state == AsyncState.loading && _currentToken != null) {
      logger.verbose('[AsyncController] Cancelling previous operation');
      _currentToken!.cancel();
    }

    final newToken = token ?? CancellationToken();
    _currentToken = newToken;

    _updateState(AsyncState.loading);

    try {
      logger.verbose('[AsyncController] Executing operation');
      final result = await Future.any([
        operation(newToken),
        newToken.onCancelled.then((_) => throw CancelledException()),
      ]);

      logger.verbose('[AsyncController] Operation completed successfully');
      _updateState(AsyncState.success, data: result);
      return result;
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
      if (_currentToken == newToken) {
        _currentToken = null;
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
  }

  void cancel() {
    if (_state == AsyncState.loading && _currentToken != null) {
      logger.verbose('[AsyncController] Manually cancelling current operation');
      _currentToken!.cancel();
    }
  }

  void reset() {
    logger.verbose('[AsyncController] Resetting controller');
    _updateState(AsyncState.initial);
    _currentToken = null;
  }

  void dispose() {
    logger.verbose('[AsyncController] Disposing controller');
    cancel();
    _stateController.close();
    _dataController.close();
    _errorController.close();
  }

  Stream<AsyncState> get stateStream => _stateController.stream;
  Stream<T?> get dataStream => _dataController.stream;
  Stream<Exception?> get errorStream => _errorController.stream;

  AsyncState get state => _state;
  T? get currentData => _data;
  Exception? get currentError => _error;
  StackTrace? get currentStackTrace => _stackTrace;
}
