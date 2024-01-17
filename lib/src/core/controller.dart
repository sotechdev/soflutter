import 'package:flutter/material.dart';

/// A controller that controls states
class Controller<TState> extends ValueNotifier<TState> {
  Controller(TState state) : super(state);

  /// Emit a state and notify listeners
  void emit(TState state) {
    super.value = state;
    notifyListeners();
  }
}
