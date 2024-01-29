import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:soflutter/src/views/busy_indicator.dart';
import 'package:soflutter/src/views/error_view.dart';

import 'controller.dart';
import 'state.dart';

/// A builder that returns a Listenable Builder
class BaseBuilder<TController extends Controller<TState>, TState>
    extends StatelessWidget {
  const BaseBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.onError,
    this.onLoading,
  });
  final TController controller;
  //final TState state;
  final Widget Function(BuildContext, TState) builder;
  final Widget? Function(BuildContext context, Object? error)? onError;
  final Widget Function(BuildContext context)? onLoading;

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (state is LoadingState) {
          if (onLoading != null) {
            return onLoading!(context);
          }
          return BusyIndicator(state.message);
        } else if (state is ErrorState) {
          if (onError != null) {
            final widget = onError!.call(context, state.error);
            if (widget != null) {
              return widget;
            }
          } else {
            logger.e(state.message);
            return ErrorView(state.message);
          }
        }
        return builder(context, state);
      },
    );
  }
}
