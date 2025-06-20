import 'package:flutter_bloc/flutter_bloc.dart';

/// A controller that controls states
class Controller<TState> extends Cubit<TState> {
  Controller(TState state) : super(state);
}
