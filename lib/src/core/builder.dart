import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide WatchContext, ReadContext;
import 'package:soflutter/src/core/logging.dart';
import 'package:soflutter/src/core/observer.dart';
import 'package:soflutter/src/views/busy_indicator.dart';
import 'package:soflutter/src/views/error_view.dart';

import 'controller.dart';
import 'state.dart';

/// Typedef para funções que constroem o Widget principal
/// Recebe o [BuildContext] e um [TState] que representa o estado.
typedef WidgetBuilder<TState> = Widget Function(
    BuildContext context, TState state);

/// Typedef para funções que constroem um widget em caso de erro.
/// Recebe o [BuildContext] e um [Object] que representa o erro.
/// Pode retornar null se não houver um widget para exibir o erro.
typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context, {
  Object? error,
  StackTrace? stackTrace,
});

/// Typedef para funções que constroem um widget para indicar carregamento.
/// Recebe apenas o [BuildContext].
typedef LoadingWidgetBuilder = Widget Function(
  BuildContext context,
);

class BaseBuilder<TController extends Controller<TState>, TState>
    extends StatelessWidget with Logging {
  BaseBuilder({
    super.key,
    required this.builder,
    this.controller,
    this.buildWhen,
    this.onError,
    this.onLoading,
  }) {
    Bloc.observer = AppObserver();
  }

  final WidgetBuilder<TState> builder;
  final TController? controller;
  final BlocBuilderCondition<TState>? buildWhen;
  final ErrorWidgetBuilder? onError;
  final LoadingWidgetBuilder? onLoading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TController, TState>(
      bloc: controller,
      builder: (context, state) {
        if (state is LoadingState) {
          if (onLoading != null) {
            return onLoading!(context);
          }
          return BusyIndicator(state.message);
        } else if (state is ErrorState) {
          if (onError != null) {
            final widget = onError?.call(
              context,
              error: state.error,
              stackTrace: state.stackTrace,
            );
            if (widget != null) {
              return widget;
            }
          } else {
            logger.error(
              state.message,
              error: state.error,
              stackTrace: state.stackTrace,
            );
            return ErrorView(state.message);
          }
        }
        return builder(context, state);
      },
      buildWhen: buildWhen,
    );
  }
}
