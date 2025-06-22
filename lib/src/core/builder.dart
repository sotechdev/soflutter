import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:soflutter/src/extensions/build_context_extensions.dart';
import 'package:soflutter/src/views/busy_indicator.dart';
import 'package:soflutter/src/views/error_view.dart';

import 'controller.dart';
import 'logging.dart';

/// A builder that returns a ScopedBuilder
class SOPageBuilder<TController extends SOController<TData>, TData>
    extends StatelessWidget with Logging {
  SOPageBuilder({
    super.key,
    required this.builder,
    this.onError,
    this.onLoading,
  });
  late final TController controller;
  final Widget Function(BuildContext context, TData state) builder;
  final Widget Function(BuildContext context, dynamic error)? onError;
  final Widget Function(BuildContext context)? onLoading;

  @override
  Widget build(BuildContext context) {
    controller = context.get<TController>();
    return ScopedBuilder(
      store: controller,
      onLoading: (context) {
        if (onLoading != null) {
          return onLoading!(context);
        } else {
          return const BusyIndicator('Carregando...');
        }
      },
      onError: (context, error) {
        if (onError != null) {
          return onError!(context, error);
        } else {
          return ErrorView(error: error);
        }
      },
      onState: builder,
    );
  }
}
