import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:soflutter/src/extensions/build_context_extensions.dart';
import 'package:soflutter/src/views/busy_indicator.dart';
import 'package:soflutter/src/views/error_view.dart';

import 'controller.dart';
import 'logging.dart';

/// A builder that returns a ScopedBuilder
class SOPageBuilder<TController extends SOController<TData>, TData>
    extends StatefulWidget {
  const SOPageBuilder({
    super.key,
    required this.builder,
    this.onError,
    this.onLoading,
  });
  final Widget Function(
    BuildContext context,
    TController controller,
    TData state,
  ) builder;
  final Widget Function(BuildContext context, dynamic error)? onError;
  final Widget Function(BuildContext context)? onLoading;

  @override
  State<SOPageBuilder<TController, TData>> createState() =>
      _SOPageBuilderState<TController, TData>();
}

class _SOPageBuilderState<TController extends SOController<TData>, TData>
    extends State<SOPageBuilder<TController, TData>> with Logging {
  late final Future<void> Function() _disposeObserver;

  late final TController controller;

  @override
  Widget build(BuildContext context) {
    controller = context.get<TController>();
    _disposeObserver = controller.observer(
      onError: (error) => logger.error('Error', error: error),
      onLoading: (loading) => logger.debug('Loading'),
      onState: (state) => logger.debug('State'),
    );
    return ScopedBuilder<TController, TData>(
      store: controller,
      onLoading: (context) {
        if (widget.onLoading != null) {
          return widget.onLoading!(context);
        } else {
          return const BusyIndicator('Carregando...');
        }
      },
      onError: (context, error) {
        if (widget.onError != null) {
          return widget.onError!(context, error);
        } else {
          return ErrorView(error: error);
        }
      },
      onState: (context, state) => widget.builder(context, controller, state),
    );
  }

  @override
  void dispose() {
    _disposeObserver();
    super.dispose();
  }
}
