import 'package:flutter_triple/flutter_triple.dart';

/// A controller that controls states
class SOController<TState> extends Store<TState> {
  SOController(TState state) : super(state);

  /// Emit a state and notify listeners
  void emit(TState state) => update(state);
}
