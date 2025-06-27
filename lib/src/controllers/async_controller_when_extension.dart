import 'package:flutter/material.dart';

import 'async_controller.dart';
import 'async_state.dart';

extension AsyncControllerWhenExtension<T> on AsyncController<T> {
  bool get isInitial => state == AsyncState.initial;
  bool get isLoading => state == AsyncState.loading;
  bool get isSuccess => state == AsyncState.success;
  bool get isError => state == AsyncState.error;
  bool get isCancelled => state == AsyncState.cancelled;

  T get data {
    if (state == AsyncState.success) {
      return currentData as T;
    }
    throw StateError('No data available in current state: $state');
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Exception error, StackTrace stackTrace) error,
    required R Function() cancelled,
  }) {
    logger.verbose('[AsyncController] when() called for state $state');
    switch (state) {
      case AsyncState.initial:
        return initial();
      case AsyncState.loading:
        return loading();
      case AsyncState.success:
        return success(currentData as T);
      case AsyncState.error:
        return error(currentError!, currentStackTrace!);
      case AsyncState.cancelled:
        return cancelled();
    }
  }

  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(Exception error, StackTrace stackTrace)? error,
    R Function()? cancelled,
    required R Function() orElse,
  }) {
    logger.verbose('[AsyncController] maybeWhen() called for state $state');
    switch (state) {
      case AsyncState.initial:
        return initial?.call() ?? orElse();
      case AsyncState.loading:
        return loading?.call() ?? orElse();
      case AsyncState.success:
        return success?.call(currentData as T) ?? orElse();
      case AsyncState.error:
        return error?.call(currentError!, currentStackTrace!) ?? orElse();
      case AsyncState.cancelled:
        return cancelled?.call() ?? orElse();
    }
  }

  Widget buildWhen({
    required Widget Function(BuildContext) initial,
    required Widget Function(BuildContext) loading,
    required Widget Function(BuildContext, T data) success,
    required Widget Function(BuildContext, Exception error, StackTrace stackTrace) error,
    required Widget Function(BuildContext) cancelled,
  }) {
    return StreamBuilder<AsyncState>(
      stream: stateStream,
      builder: (context, snapshot) {
        return when(
          initial: () => initial(context),
          loading: () => loading(context),
          success: (data) => success(context, data),
          error: (err, stack) => error(context, err, stack),
          cancelled: () => cancelled(context),
        );
      },
    );
  }
}